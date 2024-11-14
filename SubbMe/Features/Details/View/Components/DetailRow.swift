//
//  DetailRow.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 13/11/2024.
//

import SwiftUI

struct DetailRow<Detail: View>: View {
    let name: String
    @ViewBuilder let detail: Detail

    init(_ name: String, @ViewBuilder detail: () -> Detail) {
        self.name = name
        self.detail = detail()
    }

    var body: some View {
        HStack {
            Text(name)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Spacer()

            detail
                .fontWeight(.regular)
                .foregroundStyle(.white)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    DetailRow("Period") {
        Text(String(describing: Subscription.example.type))
    }
}
