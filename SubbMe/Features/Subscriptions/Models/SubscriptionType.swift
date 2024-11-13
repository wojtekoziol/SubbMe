//
//  SubscriptionType.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 11/11/2024.
//

import Foundation

enum SubscriptionType: CaseIterable, Codable, CustomStringConvertible, Hashable {
    case annually, monthly, weekly, daily

    var description: String  {
        switch self {
        case .annually:
            "Annually"
        case .monthly:
            "Monlthy"
        case .weekly:
            "Weekly"
        case .daily:
            "Daily"
        }
    }
}
