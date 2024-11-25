//
//  SubscriptionsCalendarView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Factory
import SwiftUI

struct CalendarView: View {
    @Environment(SubscriptionsViewModel.self) private var subscriptionsVM

    let weekdaySymbols = Calendar.current.shortWeekdaySymbols

    @State private var color = Color.blue
    @State private var selectedDate = Date.now

    @State private var overlayPresented = false

    @State private var offset = 0
    @State private var animationRunning = false

    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, yyyy"
        return formatter.string(from: selectedDate)
    }

    var monthlyTotalInCurrency: [String: Double] {
        var total = [String: Double]()

        for currencyCode in Constants.availableCurrencies {
            let currencyTotal = subscriptionsVM.subscriptions.monthlyTotal(date: selectedDate, currencyCode: currencyCode)
            guard currencyTotal != 0 else { continue }
            total[currencyCode] = (total[currencyCode] ?? 0) + currencyTotal
        }

        return total
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Button {
                    selectedDate = .now
                } label: {
                    Text(monthTitle)
                        .font(.title)
                        .bold()
                }

                Spacer()

                HStack(spacing: 20) {
                    Button {
                        guard !animationRunning else { return }

                        withAnimation(.spring(duration: Constants.animationDuration)) {
                            animationRunning = true
                            offset += 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }

                    Button {
                        guard !animationRunning else { return }

                        withAnimation(.spring(duration: Constants.animationDuration)) {
                            animationRunning = true
                            offset -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .buttonStyle(.plain)


            VStack {
                HStack {
                    ForEach(weekdaySymbols.indices, id: \.self) { index in
                        Text(weekdaySymbols[index])
                            .frame(maxWidth: .infinity)
                    }
                }

                ZStack {
                    CalendarDaysView(selectedDate: selectedDate.previousMonth)
                        .offset(x: (Double(offset) - 1) * UIScreen.screenWidth)

                    CalendarDaysView(selectedDate: selectedDate)
                        .offset(x: Double(offset) * UIScreen.screenWidth)

                    CalendarDaysView(selectedDate: selectedDate.nextMonth)
                        .offset(x: (Double(offset) + 1) * UIScreen.screenWidth)
                }
            }
            .gesture(DragGesture()
                .onEnded { value in
                    guard !animationRunning else { return }

                    withAnimation(.spring(duration: Constants.animationDuration)) {
                        animationRunning = true

                        if value.translation.width < 0 { offset -= 1 }
                        if value.translation.width > 0 { offset += 1 }
                    }
                }
            )

            VStack(alignment: .leading) {
                ForEach(monthlyTotalInCurrency.sorted { $0.key < $1.key }, id: \.key) { item in
                    Text("Monthly total: ")
                        .foregroundStyle(.secondary)
                    + Text(item.value.asPrice(currencyCode: item.key))
                }
                .font(.subheadline)
            }

            Spacer()
        }
        .onChange(of: offset) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.animationDuration) {
                selectedDate = Calendar.current.date(byAdding: .month, value: -offset, to: selectedDate)!
                offset = 0
                animationRunning = false
            }
        }
        .frame(maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    @Previewable @Namespace var animation
    Container.shared.preview()
    return CalendarView()
        .environment(SubscriptionsViewModel())
}
