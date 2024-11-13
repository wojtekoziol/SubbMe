//
//  ModelContainer+Preview.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 11/11/2024.
//

import Foundation
import SwiftData

extension ModelContainer {
    @MainActor
    static var preview: ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Subscription.self, configurations: config)

        container.mainContext.insert(Subscription.example)

        return container
    }
}
