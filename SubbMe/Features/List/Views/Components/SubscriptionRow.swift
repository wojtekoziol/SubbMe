//
//  SubscriptionRow.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import SwiftUI

struct SubscriptionRow: View {
    let subscription: Subscription

    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "creditcard")

            VStack(alignment: .leading) {
                Text(subscription.name)
                    .font(.title3)
                    .bold()
                    .lineLimit(1)

                Text("Next bill: ")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                + Text(subscription.nextBill.formattedString(style: .medium))
                    .font(.caption)
            }

            Spacer()

            Text("$6.10")
                .foregroundStyle(.secondary)
                .bold()
        }
    }
}

#Preview {
    List {
        SubscriptionRow(subscription: Subscription.example)
    }
}
