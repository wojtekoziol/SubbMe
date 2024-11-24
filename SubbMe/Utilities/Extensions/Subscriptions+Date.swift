//
//  Subscriptions.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 24/11/2024.
//

import Foundation

extension [Subscription] {
    func forDay(_ date: Date) -> [Subscription] {
        self.filter { subscription in
            Calendar.current.isDate(
                subscription.nextBill ?? subscription.dateEnding ?? subscription.dateStarted,
                inSameDayAs: date)
        }
    }

    func forMonth(date: Date = .now) -> [Subscription] {
        let currentComponents = Calendar.current.dateComponents([.month, .year], from: date)
        let currentMonth = currentComponents.month
        let currentYear = currentComponents.year

        return self.filter { subscription in
            let subComponents = Calendar.current.dateComponents([.month, .year], from: subscription.nextBill ?? subscription.dateEnding ?? subscription.dateStarted)
            return subComponents.month == currentMonth && subComponents.year == currentYear
        }
    }

    func monthlyTotal(date: Date = .now, currencyCode: String) -> Double {
        self.forMonth(date: date).filter { $0.currencyCode == currencyCode }.reduce(0) { partialResult, subscription in
            partialResult + subscription.price
        }
    }
}
