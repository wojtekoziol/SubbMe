//
//  IconButton.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import SwiftUI

struct IconButton: View {
    let systemImage: String
    let action: () -> Void

    init(systemImage: String, action: @escaping @MainActor () -> Void) {
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button{
            action()
        } label: {
            Image(systemName: systemImage)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(10)
                .background(.regularMaterial)
                .clipShape(.circle)
        }
    }
}

#Preview {
    IconButton(systemImage: "plus") { }
}
