//
//  SwiftDataDatabaseService.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Foundation
import SwiftData

@MainActor
class SwiftDataService: DatabaseService {
    let container: ModelContainer

    private var context: ModelContext {
        container.mainContext
    }

    init() {
        let config = ModelConfiguration()
        container = try! ModelContainer(for: Subscription.self, configurations: config)
    }

    // MARK: - User

    func fetchUser() -> User? {
        let descriptor = FetchDescriptor<User>()
        return try? context.fetch(descriptor).first
    }

    func updateUser(_ user: User) {
        let existingUser = fetchUser()
        if let existingUser {
            context.delete(existingUser)
        }
        context.insert(user)
    }

    // MARK: - Subscriptions

    func fetchSubscriptions(sort: [SortDescriptor<Subscription>]) -> [Subscription] {
        var descriptor = FetchDescriptor<Subscription>()
        descriptor.sortBy = sort
        let fetchedSubscriptions = try? context.fetch(descriptor)
        return fetchedSubscriptions ?? []
    }

    func addSubscription(_ subscription: Subscription) {
        context.insert(subscription)
    }

    func deleteSubscription(_ subscription: Subscription) {
        context.delete(subscription)
    }

    func updateAllSubscriptions(_ subscriptions: [Subscription]) {
        try? context.delete(model: Subscription.self)
        for subscription in subscriptions {
            context.insert(subscription)
        }
    }
}


