//
//  SwiftDataDatabaseService.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Foundation
import SwiftData

@MainActor
struct SwiftDataService: DatabaseService {
    let container: ModelContainer

    private var context: ModelContext {
        container.mainContext
    }

    init() {
        let config = ModelConfiguration()
        container = try! ModelContainer(for: Subscription.self, configurations: config)
    }

    func fetchSubscriptions() -> [Subscription] {
        let descriptor = FetchDescriptor<Subscription>()
        let fetchedSubscriptions = try? context.fetch(descriptor)
        return fetchedSubscriptions ?? []
    }

    func addSubscription(_ subscription: Subscription) {
        context.insert(subscription)
    }
}


