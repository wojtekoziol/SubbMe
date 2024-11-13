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
        Subscription(name: "Spotify", type: .monthly, price: 20, currencyCode: "EUR", dateStartedAsInterval: Date().timeIntervalSince1970)
    }
}
