//
//  PersistanceController.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import SwiftUI

@MainActor
protocol DatabaseService {
    func fetchUser() -> User?
    func updateUser(_ user: User)
    func fetchSubscriptions(sort: [SortDescriptor<Subscription>]) -> [Subscription]
    func addSubscription(_ subscription: Subscription)
    func deleteSubscription(_ subscription: Subscription)
    func updateAllSubscriptions(_ subscriptions: [Subscription])
}

extension DatabaseService {
    func saveWidgetSubscriptions(_ subscriptions: [Subscription]) {
        guard let userDefaults = UserDefaults(suiteName: "group.com.wojciechkoziol.SubbMe") else { return }

        userDefaults.removePersistentDomain(forName: "group.com.wojciechkoziol.SubbMe")
        userDefaults.synchronize()

        let dates = subscriptions.compactMap(\.nextDate)
        for date in dates {
            let subsciptions = subscriptions.filter { $0.nextDate == date }
            if let data = try? JSONEncoder().encode(subsciptions) {
                userDefaults.set(data, forKey: date.asKey())
            }
        }
    }
}

// MARK: - Mock

class MockDatabaseService: DatabaseService {
    func fetchUser() -> User? { User.example }

    func updateUser(_ user: User) { }

    func fetchSubscriptions(sort: [SortDescriptor<Subscription>]) -> [Subscription] { [Subscription.example] }

    func addSubscription(_ subscription: Subscription) { }

    func deleteSubscription(_ subscription: Subscription) { }

    func updateAllSubscriptions(_ subscriptions: [Subscription]) { }
}
