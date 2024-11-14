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
    var showingEditSheet = false
    private(set) var showingDetailsScreen = false
    private(set) var selectedSubscription: Subscription?

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService

        fetchSubscriptions()
    }

    func fetchSubscriptions() {
        Task {
            subscriptions = await databaseService.fetchSubscriptions(sort: [SortDescriptor<Subscription>(\.dateStartedAsInterval)])
        }
    }

    func showEditScreen(for subscription: Subscription? = nil) {
        selectedSubscription = subscription
        showingEditSheet = true
    }

    func showDetails(for subscription: Subscription) {
        selectedSubscription = subscription
        showingDetailsScreen = true
    }

    func hideDetails() {
        showingDetailsScreen = false
    }
}
