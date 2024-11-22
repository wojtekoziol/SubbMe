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

// MARK: - Mock

class MockDatabaseService: DatabaseService {
    func fetchUser() -> User? { User.example }

    func updateUser(_ user: User) { }

    func fetchSubscriptions(sort: [SortDescriptor<Subscription>]) -> [Subscription] { [Subscription.example] }

    func addSubscription(_ subscription: Subscription) { }

    func deleteSubscription(_ subscription: Subscription) { }

    func updateAllSubscriptions(_ subscriptions: [Subscription]) { }
}
