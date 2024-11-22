//
//  SubscriptionType.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 11/11/2024.
//

import Foundation

enum SubscriptionType: String, CaseIterable, Codable, CustomStringConvertible {
    case annually, monthly, weekly, daily

    var description: String {
        self.rawValue.capitalizedFirstLetter()
    }
}
