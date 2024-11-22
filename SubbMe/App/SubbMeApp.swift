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
    var body: some Scene {
        WindowGroup {
            AuthWrapperView()
                .preferredColorScheme(.dark)
        }
    }
}
