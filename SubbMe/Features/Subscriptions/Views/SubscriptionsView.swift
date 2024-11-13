//
//  NavigationView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import SwiftData
import SwiftUI

struct SubscriptionsView: View {
    @Environment(\.databaseService) private var databaseService

    @State private var vm: SubscriptionsViewModel

    init(databaseService: any DatabaseService) {
        self._vm = State(wrappedValue: SubscriptionsViewModel(databaseService: databaseService))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    ViewSelector(name: "Calendar", viewType: .calendar, currentViewType: $vm.viewType)
                    
                    ViewSelector(name: "List", viewType: .list, currentViewType: $vm.viewType)

                    Spacer()

                    IconButton(systemImage: "plus") {
                        vm.showEditScreen()
                    }
                }
                .padding()

                Divider()

                switch vm.viewType {
                case .list:
                    ListView()
                case .calendar:
                    CalendarView()
                }
            }
        }
        .sheet(isPresented: $vm.showingEditSheet) {
            EditSubscriptionView(databaseService: databaseService, subscription: vm.selectedSubscription)
                .presentationDragIndicator(.visible)
        }
        .environment(vm)
    }
}

#Preview {
    SubscriptionsView(databaseService: SwiftDataService(container: ModelContainer.preview))
}
