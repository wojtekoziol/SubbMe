//
//  SubscriptionsListViewModel.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Foundation

@Observable
class SubscriptionsViewModel {
    private let databaseService: DatabaseService

    private(set) var subscriptions = [Subscription]()

    var viewType: ViewType = .calendar

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService

        fetchSubscriptions()
    }

    // MARK: - Data

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

    // MARK: - View
}
