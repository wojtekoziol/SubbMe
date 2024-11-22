//
//  SubbMeApp+Injected.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 22/11/2024.
//

import Factory
import SwiftUI

extension Container {
    var databaseService: Factory<DatabaseService> {
        Factory(self) {
            MainActor.assumeIsolated {
                SwiftDataService()
            }
        }
    }

    var apiService: Factory<ApiServiceProtocol> {
        Factory(self) {
            ApiService()
        }
    }

    func preview() {
        // Database Servicc
        Container.shared.databaseService.register {
            MainActor.assumeIsolated {
                MockDatabaseService()
            }
        }

        // Api Service
        Container.shared.apiService.register {
            MockApiService()
        }
    }
}
