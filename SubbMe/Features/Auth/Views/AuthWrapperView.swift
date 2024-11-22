//
//  AuthWrapperView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 21/11/2024.
//

import Factory
import SwiftUI
import SwiftData

struct AuthWrapperView: View {
    @State private var vm = AuthViewModel()

    var body: some View {
        if vm.user != nil {
            SubscriptionsView()
        } else {
            LoginView()
                .environment(vm)
        }
    }
}

#Preview {
    Container.shared.preview()
    return AuthWrapperView()
}
