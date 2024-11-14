//
//  PriceTagView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 13/11/2024.
//

import SwiftUI

struct PriceTagView: View {
    let price: Double
    let currencyCode: String

    var body: some View {
        Text(price.asPrice(currencyCode: currencyCode))
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.darkGreen)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.darkGreen, lineWidth: 5)
                    .fill(.white)
                    .fill(.green.opacity(0.15))
            )
    }
}

#Preview {
    PriceTagView(price: Subscription.example.price, currencyCode: Subscription.example.currencyCode)
}
