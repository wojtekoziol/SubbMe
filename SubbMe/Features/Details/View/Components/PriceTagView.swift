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
            .foregroundStyle(.green)
            .padding(5)
            .background(.white)
    }
}

#Preview {
    PriceTagView(price: Subscription.example.price, currencyCode: Subscription.example.currencyCode)
}
