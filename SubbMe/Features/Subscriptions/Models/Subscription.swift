//
//  Subscription.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Foundation
import SwiftData

@Model
class Subscription: Identifiable, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case price
        case currencyCode
        case dateStartedAsInterval
        case dateEndingAsInterval
        case websiteURL
    }

    var id: UInt64? = nil
    var name: String
    var type: SubscriptionType
    var price: Double
    var currencyCode: String
    var dateStartedAsInterval: Double
    var dateEndingAsInterval: Double?
    var websiteURL: String?

    init(name: String, type: SubscriptionType, price: Double, currencyCode: String, dateStartedAsInterval: Double, dateEndingAsInterval: Double? = nil, websiteURL: String? = nil) {
        self.name = name
        self.type = type
        self.price = price
        self.currencyCode = currencyCode
        self.dateStartedAsInterval = dateStartedAsInterval
        self.dateEndingAsInterval = dateEndingAsInterval
        self.websiteURL = websiteURL
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UInt64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(SubscriptionType.self, forKey: .type)
        price = try container.decode(Double.self, forKey: .price)
        currencyCode = try container.decode(String.self, forKey: .currencyCode)
        dateStartedAsInterval = try container.decode(Double.self, forKey: .dateStartedAsInterval)
        dateEndingAsInterval = try container.decodeIfPresent(Double.self, forKey: .dateEndingAsInterval)
        websiteURL = try container.decodeIfPresent(String.self, forKey: .websiteURL)
    }

    convenience init() {
        self.init(name: "", type: .monthly, price: 0, currencyCode: "EUR", dateStartedAsInterval: Date().timeIntervalSince1970)
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
        Subscription(name: "Spotify", type: .monthly, price: 20, currencyCode: "EUR", dateStartedAsInterval: Date().timeIntervalSince1970, websiteURL: "google.com")
    }
}
