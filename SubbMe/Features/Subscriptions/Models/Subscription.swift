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
    var price: Decimal
    var currencyCode: String
    var dateStartedAsInterval: Double
    var dateEndingAsInterval: Double?
    var websiteURL: String?

    init(name: String, type: SubscriptionType, price: Decimal, currencyCode: String, dateStartedAsInterval: Double, dateEndingAsInterval: Double? = nil, websiteURL: String? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.type = type
        self.price = price
        self.currencyCode = currencyCode
        self.dateStartedAsInterval = dateStartedAsInterval
        self.dateEndingAsInterval = dateEndingAsInterval
        self.websiteURL = websiteURL
    }

    static var example: Subscription {
        Subscription(name: "Spotify", type: .monthly, price: 20, currencyCode: "USD", dateStartedAsInterval: Date().timeIntervalSince1970)
    }
}
