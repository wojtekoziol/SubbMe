//
//  CalendarComponentView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 24/11/2024.
//

import Factory
import SwiftUI

struct CalendarDaysView: View {
    @Environment(SubscriptionsViewModel.self) private var subscriptionsVM

    let selectedDate: Date

    let columns = Array(repeating: GridItem(.flexible()), count: 7)

    @State private var days = [Date]()

    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    if (day.isSameMonth(as: selectedDate)) {
                        DayView(
                            date: day,
                            subscriptions: subscriptionsVM.subscriptions.forDay(day)
                        )
                    } else {
                        Text("")
                    }
                }
            }
        }
        .onAppear {
            days = selectedDate.calendarDisplayDays
        }
        .onChange(of: selectedDate) { oldValue, newValue in
            days = selectedDate.calendarDisplayDays
        }
    }
}

#Preview {
    Container.shared.preview()
    return CalendarDaysView(selectedDate: .now)
        .environment(SubscriptionsViewModel())
}
