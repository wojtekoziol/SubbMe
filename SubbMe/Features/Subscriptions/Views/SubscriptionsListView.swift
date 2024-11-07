//
//  ContentView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import SwiftUI
import SwiftData

struct SubscriptionsListView: View {
    @State private var vm: SubscriptionsListViewModel

    init(databaseService: DatabaseService) {
        self._vm = State(wrappedValue: SubscriptionsListViewModel(databaseService: databaseService))
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.subscriptions) { subscription in
                    Text(subscription.name)
                }
            }
            .toolbar {
                Button("Add") {
                    vm.addSubscription()
                }
            }
        }
    }
}

#Preview {
    return SubscriptionsListView(databaseService: SwiftDataService(preview: true))
}
