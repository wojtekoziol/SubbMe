//
//  LoginView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 22/11/2024.
//

import Factory
import SwiftData
import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var authVM

    var body: some View {
        @Bindable var authVM = authVM

        VStack {
            TextField("Email", text: $authVM.email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)

            SecureField("Password", text: $authVM.password)

            TextField("First Name", text: $authVM.firstName)

            TextField("Last Name", text: $authVM.lastName)
                .autocorrectionDisabled()

            Button("Login") {
                Task {
                    await authVM.login()
                }
            }

            Button("Register") {
                Task {
                    await authVM.register()
                }
            }
        }
    }
}

#Preview {
    Container.shared.preview()
    return LoginView()
        .environment(AuthViewModel())
}
