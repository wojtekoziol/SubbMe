//
//  SubbMeApp.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import SwiftData
import SwiftUI

@main
struct SubbMeApp: App {
    let databaseService = SwiftDataService()

    var body: some Scene {
        WindowGroup {
            SubscriptionsView(databaseService: databaseService)
                .preferredColorScheme(.dark)
        }
        .environment(\.databaseService, databaseService)
    }
}
