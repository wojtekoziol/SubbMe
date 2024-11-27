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
//        do {
//            guard let bundleURL = Bundle.main.url(forResource: "default", withExtension: "store") else {
//                fatalError("Failed to find default.store in app bundle")
//            }
//
//            let fileManager = FileManager.default
//            let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let documentURL = documentDirectoryURL.appendingPathComponent("default.store")
//
//            // Only copy the store from the bundle to the Documents directory if it doesn't exist
//            if !fileManager.fileExists(atPath: documentURL.path) {
//                try fileManager.copyItem(at: bundleURL, to: documentURL)
//            }
//
//            let configuration = ModelConfiguration(url: documentURL)
//            container = try ModelContainer(for: Subscription.self, configurations: configuration)
//        } catch {
//            fatalError("Could not create SwiftDataService: \(error.localizedDescription)")
//        }
        let storeURL = URL.documentsDirectory.appending(path: "database.sqlite")
        let config = ModelConfiguration(url: storeURL)
        do {
            container = try ModelContainer(for: Subscription.self, configurations: config)
        } catch {
            fatalError("Could not create SwiftDataService: \(error.localizedDescription)")
        }
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


