//
//  DayView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 24/11/2024.
//

import SwiftUI

struct DayView: View {
    let date: Date
    let subscriptions: [Subscription]

    var isActive: Bool {
        subscriptions.reduce(false) { partialResult, subscription in
            partialResult || subscription.isActive
        }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 5) {
                Image(systemName: "creditcard")
                    .opacity(subscriptions.isEmpty ? 0 : 1)

                Text(date.formatted(.dateTime.day()))
                    .foregroundStyle(Calendar.current.isDate(date, inSameDayAs: .now) ? .primary : .secondary)
                    .fontWeight(Calendar.current.isDate(date, inSameDayAs: .now) ? .semibold : .regular)
            }
            .font(.caption)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 10))

            if isActive {
                Circle()
                    .fill(.darkGreen)
                    .frame(width: 5)
                    .padding(5)
            }
        }
    }
}

#Preview {
    DayView(date: .now, subscriptions: [.example])
}
