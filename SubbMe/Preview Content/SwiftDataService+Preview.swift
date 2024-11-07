//
//  Pre.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Foundation
import SwiftData

extension SwiftDataService {
    convenience init(preview: Bool) {
        let config = ModelConfiguration(isStoredInMemoryOnly: preview)
        let container = try! ModelContainer(for: Subscription.self, configurations: config)

        self.init(container: container)

        if preview {
            self.container.mainContext.insert(Subscription.example)
        }
    }
}
