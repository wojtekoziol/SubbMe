//
//  AuthWrapperView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 21/11/2024.
//

import SwiftUI
import SwiftData

struct AuthWrapperView: View {
    @Environment(\.databaseService) private var databaseService
    @State private var vm: AuthViewModel

    init(databaseService: DatabaseService, apiService: ApiService) {
        self._vm = State(wrappedValue: AuthViewModel(databaseService: databaseService, apiService: apiService))
    }

    var body: some View {
        if let user = vm.user {
            SubscriptionsView(databaseService: databaseService)
        } else {
            LoginView()
                .environment(vm)
        }
    }
}

#Preview {
    let databaseService = SwiftDataService(container: ModelContainer.preview)
    return AuthWrapperView(databaseService: databaseService, apiService: ApiService())
        .environment(\.databaseService, databaseService)
}
