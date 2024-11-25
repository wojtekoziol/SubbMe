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
        }
        .overlay {
            if vm.showingDayDetails {
                DayDetailsView(date: vm.selectedDate)
                    .containerRelativeFrame(.horizontal) { width, _ in
                        width * 0.8
                    }
                    .onTapGesture { }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .background(.ultraThinMaterial)
                    .onTapGesture {
                        vm.hideDayDetails()
                    }
                    .transition(.opacity)
            }
        }
        .overlay {
            if let selectedSubscription = vm.selectedSubscription, vm.showingDetailsScreen {
                DetailsView(subscription: selectedSubscription, animation: animation)
            }
        }
        .animation(.spring(duration: Constants.animationDuration), value: vm.showingDayDetails)
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
