//
//  SubscriptionsListViewModel.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Foundation

@Observable
class SubscriptionsListViewModel {
    private let databaseService: DatabaseService

    private(set) var subscriptions = [Subscription]()

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService

        fetchSubscriptions()
    }

    func fetchSubscriptions() {
        Task {
            subscriptions = await databaseService.fetchSubscriptions()
        }
    }

    func addSubscription() {
        Task {
            await databaseService.addSubscription(Subscription.example)
            fetchSubscriptions()
        }
    }
}
