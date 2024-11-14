//
//  Subscription.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Foundation
import SwiftData

@Model
class Subscription: Identifiable {
    var id: String
    var name: String
    var type: SubscriptionType
    var price: Double
    var currencyCode: String
    var dateStartedAsInterval: Double
    var dateEndingAsInterval: Double?
    var websiteURL: String?

    init(name: String, type: SubscriptionType, price: Double, currencyCode: String, dateStartedAsInterval: Double, dateEndingAsInterval: Double? = nil, websiteURL: String? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.type = type
        self.price = price
        self.currencyCode = currencyCode
        self.dateStartedAsInterval = dateStartedAsInterval
        self.dateEndingAsInterval = dateEndingAsInterval
        self.websiteURL = websiteURL
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
