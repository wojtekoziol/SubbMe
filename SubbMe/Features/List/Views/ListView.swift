//
//  ContentView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Factory
import SwiftUI
import SwiftData

struct ListView: View {
    @Environment(SubscriptionsViewModel.self) private var vm

    var body: some View {
        List {
            ForEach(vm.subscriptions) { subscription in
                SubscriptionRow(subscription: subscription)
                    .contentShape(.rect)
                    .onTapGesture {
                        vm.showDetails(for: subscription)
                    }
            }
        }
        .refreshable {
            Task { await vm.fetchSubscriptions() }
        }
    }
}

#Preview {
    Container.shared.preview()
    return ListView()
        .environment(SubscriptionsViewModel())
}

