//
//  Pre.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Foundation
import SwiftData

extension SwiftDataService {
    init(preview: Bool) {
        let config = ModelConfiguration(isStoredInMemoryOnly: preview)
        container = try! ModelContainer(for: Subscription.self, configurations: config)

        if preview {
            container.mainContext.insert(Subscription.example)
        }
    }
}
