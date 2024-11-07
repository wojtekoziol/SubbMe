//
//  ContentView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import SwiftUI
import SwiftData

struct SubscriptionsListView: View {
    @Environment(SubscriptionsViewModel.self) private var vm

    var body: some View {
        List {
            ForEach(vm.subscriptions) { subscription in
                SubscriptionRow(subscription: subscription)
            }
        }
    }
}

#Preview {
    SubscriptionsListView()
        .environment(SubscriptionsViewModel(databaseService: SwiftDataService(preview: true)))
}

