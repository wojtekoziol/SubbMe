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
            // TODO: Insert icon
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading) {
                Text(subscription.name)
                    .font(.title3)
                    .bold()

                Text("Next bill:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
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
