//
//  PersistanceController.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import SwiftUI

@MainActor
protocol DatabaseService {
    func fetchUser() -> User?
    func addUser(_ user: User)
    func fetchSubscriptions(sort: [SortDescriptor<Subscription>]) -> [Subscription]
    func addSubscription(_ subscription: Subscription)
    func deleteSubscription(_ subscription: Subscription)
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
