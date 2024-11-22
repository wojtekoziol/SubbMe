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
    let apiService = ApiService()

    var body: some Scene {
        WindowGroup {
            AuthWrapperView(databaseService: databaseService, apiService: apiService)
                .preferredColorScheme(.dark)
        }
        .environment(\.databaseService, databaseService)
        .environment(\.apiService, apiService)
    }
}
