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

    init(container: ModelContainer) {
        self.container = container
    }

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
}


