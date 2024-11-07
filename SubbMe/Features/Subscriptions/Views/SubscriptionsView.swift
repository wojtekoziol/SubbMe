//
//  NavigationView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import SwiftData
import SwiftUI

struct SubscriptionsView: View {
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

                    }
                }
                .padding()

                Divider()

                switch vm.viewType {
                case .list:
                    SubscriptionsListView()
                case .calendar:
                    SubscriptionsCalendarView()
                }
            }
        }
        .environment(vm)
    }
}

#Preview {
    SubscriptionsView(databaseService: SwiftDataService(preview: true))
}
