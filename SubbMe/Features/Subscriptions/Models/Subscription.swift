//
//  Subscription.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Foundation
import SwiftData

@Model
class Subscription: Identifiable, Codable, NSCopying {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case price
        case currencyCode
        case dateStartedAsInterval
        case dateEndingAsInterval
        case websiteURL
        case reminderDays
    }

    var id: UInt64? = nil
    var name: String
    var type: SubscriptionType
    var price: Double
    var currencyCode: String
    var dateStartedAsInterval: Double
    var dateEndingAsInterval: Double?
    var websiteURL: String?
    var reminderDays: Int?

    init(id: UInt64? = nil, name: String, type: SubscriptionType, price: Double, currencyCode: String, dateStartedAsInterval: Double, dateEndingAsInterval: Double? = nil, websiteURL: String? = nil, reminderDays: Int? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.price = price
        self.currencyCode = currencyCode
        self.dateStartedAsInterval = dateStartedAsInterval
        self.dateEndingAsInterval = dateEndingAsInterval
        self.websiteURL = websiteURL
        self.reminderDays = reminderDays
    }

    convenience init() {
        self.init(name: "", type: .monthly, price: 0, currencyCode: "EUR", dateStartedAsInterval: Date().timeIntervalSince1970)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UInt64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        let typeString = try container.decode(String.self, forKey: .type)
        guard let subscriptionType = SubscriptionType(rawValue: typeString.lowercased()) else {
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid subscription type value: \(typeString)")
        }
        type = subscriptionType

        price = try container.decode(Double.self, forKey: .price)
        currencyCode = try container.decode(String.self, forKey: .currencyCode)
        dateStartedAsInterval = try container.decode(Double.self, forKey: .dateStartedAsInterval)
        dateEndingAsInterval = try container.decodeIfPresent(Double.self, forKey: .dateEndingAsInterval)
        websiteURL = try container.decodeIfPresent(String.self, forKey: .websiteURL)
        reminderDays = try container.decodeIfPresent(Int.self, forKey: .reminderDays)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type.rawValue.uppercased(), forKey: .type)
        try container.encode(price, forKey: .price)
        try container.encode(currencyCode, forKey: .currencyCode)
        try container.encode(dateStartedAsInterval, forKey: .dateStartedAsInterval)
        try container.encode(dateEndingAsInterval, forKey: .dateEndingAsInterval)
        try container.encode(websiteURL, forKey: .websiteURL)
        try container.encode(reminderDays, forKey: .reminderDays)
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Subscription(id: id, name: name, type: type, price: price, currencyCode: currencyCode, dateStartedAsInterval: dateStartedAsInterval, dateEndingAsInterval: dateEndingAsInterval, websiteURL: websiteURL, reminderDays: reminderDays)
        return copy
    }

    var nextBill: Date? {
        if Date() < dateStarted {
            return dateStarted
        }

        let component: Calendar.Component
        switch type {
        case .daily:
            component = .day
        case .weekly:
            component = .weekOfYear
        case .monthly:
            component = .month
        case .annually:
            component = .year
        }

        var nextDate = dateStarted
        while nextDate <= Date() {
            guard let updatedDate = Calendar.current.date(byAdding: component, value: 1, to: nextDate) else {
                return nil
            }
            nextDate = updatedDate
        }

        if let endDate = dateEnding, nextDate > endDate {
            return nil
        }

        return nextDate
    }

    var reminderDate: Date? {
        guard let date = nextBill ?? dateEnding, let reminderDays else { return nil }
        return Calendar.current.date(byAdding: .day, value: -reminderDays, to: date)
    }

    var isActive: Bool {
        if let dateEndingAsInterval {
            let dateEnding = Date(timeIntervalSince1970: dateEndingAsInterval)
            return dateEnding > Date()
        }
        return true
    }

    var dateStarted: Date {
        Date(timeIntervalSince1970: dateStartedAsInterval)
    }

    var dateEnding: Date? {
        if let dateEndingAsInterval {
            Date(timeIntervalSince1970: dateEndingAsInterval)
        } else {
            nil
        }
    }

    static var example: Subscription {
        Subscription(name: "Spotify", type: .monthly, price: 20, currencyCode: "EUR", dateStartedAsInterval: Date.now.timeIntervalSince1970, websiteURL: "google.com", reminderDays: 2)
    }
}
