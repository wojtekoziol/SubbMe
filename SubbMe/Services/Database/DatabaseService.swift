//
//  PersistanceController.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import Foundation
import SwiftUI

@MainActor
protocol DatabaseService {
    func fetchSubscriptions() -> [Subscription]
    func addSubscription(_ subscription: Subscription)
}

// MARK: - Environment

struct DatabaseServiceKey: EnvironmentKey {
    @MainActor
    static var defaultValue: DatabaseService = SwiftDataService()
}

extension EnvironmentValues {
    @MainActor
    var databaseService: DatabaseService {
        get { self[DatabaseServiceKey.self] }
        set { self[DatabaseServiceKey.self] = newValue }
    }
}
