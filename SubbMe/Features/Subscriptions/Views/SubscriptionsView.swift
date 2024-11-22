//
//  NavigationView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Factory
import SwiftData
import SwiftUI

struct SubscriptionsView: View {
    @Namespace private var animation

    @State private var vm = SubscriptionsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 10) {
                        ViewSelector(name: "Calendar", viewType: .calendar, currentViewType: $vm.viewType)

                        ViewSelector(name: "List", viewType: .list, currentViewType: $vm.viewType)

                        Spacer()

                        IconButton(systemImage: "plus") {
                            vm.showEditScreen()
                        }
                        .matchedGeometryEffect(id: "icon-button", in: animation)
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

                if let selectedSubscription = vm.selectedSubscription, vm.showingDetailsScreen {
                    DetailsView(subscription: selectedSubscription, animation: animation)
                }
            }
        }
        .sheet(isPresented: $vm.showingEditSheet) {
            EditSubscriptionView(subscription: vm.selectedSubscription)
                .presentationDragIndicator(.visible)
        }
        .environment(vm)
    }
}

#Preview {
    Container.shared.preview()
    return SubscriptionsView()
}
