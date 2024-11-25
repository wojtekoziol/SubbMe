//
//  DayDetailsView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 25/11/2024.
//

import Factory
import SwiftUI

struct DayDetailsView: View {
    @Environment(SubscriptionsViewModel.self) private var subscriptionsVM

    let date: Date

    var body: some View {
        VStack {
            ForEach(subscriptionsVM.detailsSubscriptions) { subscription in
                Button {
                    subscriptionsVM.showDetails(for: subscription)
                } label: {
                    HStack {
                        Image(systemName: "creditcard")
                        Text(subscription.name)

                        Spacer()

                        Text(subscription.price.asPrice(currencyCode: subscription.currencyCode))
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .fontWeight(.semibold)
                    .background(.ultraThickMaterial)
                    .clipShape(.capsule)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 20)

            Text(date.formattedString(style: .medium))
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.regularMaterial)
        .background(.gray.opacity(0.5))
        .clipShape(.rect(cornerRadius: 30))
    }
}

#Preview {
    Container.shared.preview()
    return DayDetailsView(date: .now)
        .environment(SubscriptionsViewModel())
}
