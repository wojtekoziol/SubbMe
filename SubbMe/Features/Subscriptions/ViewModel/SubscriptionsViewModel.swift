//
//  SubscriptionsListViewModel.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Factory
import Foundation

@Observable
class SubscriptionsViewModel {
    @ObservationIgnored
    @Injected(\.databaseService) private var databaseService
    @ObservationIgnored
    @Injected(\.apiService) private var apiService

    private(set) var subscriptions = [Subscription]()
    var viewType: ViewType = .calendar
    var showingEditSheet = false
    private(set) var showingDetailsScreen = false
    private(set) var selectedSubscription: Subscription?

    init() {
        Task {
            await fetchSubscriptions()
        }
    }

    func fetchSubscriptions() async {
        do {
            let subscriptions = try await apiService.fetchSubscriptions()
            self.subscriptions = subscriptions
            await databaseService.updateAllSubscriptions(subscriptions)
        } catch {
            print("Error fetching subscriptions from api: \(error.localizedDescription)")
            print("Fetching subscriptions locally")
            self.subscriptions = await databaseService.fetchSubscriptions(sort: [SortDescriptor<Subscription>(\.dateStartedAsInterval)])
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
