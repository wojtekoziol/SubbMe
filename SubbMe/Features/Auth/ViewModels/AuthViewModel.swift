//
//  AuthViewModel.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 21/11/2024.
//

import Factory
import Foundation

@Observable
class AuthViewModel {
    @ObservationIgnored
    @Injected(\.databaseService) private var databaseService
    @ObservationIgnored
    @Injected(\.apiService) private var apiService

    private(set) var user: User?

    var email = ""
    var password = ""
    var firstName = ""
    var lastName = ""

    func login() async {
        let loginDTO = LoginDTO(email: email, password: password)
        guard loginDTO.validate() else { return }

        do {
            let loggedUser = try await apiService.login(with: loginDTO)
            self.user = loggedUser
            await databaseService.updateUser(loggedUser)
        } catch {
            print("Login error: \(error.localizedDescription)")
        }
    }

    func register() async {
        let registerDTO = RegisterDTO(email: email, password: password, firstName: firstName, lastName: lastName)
        guard registerDTO.validate() else { return }

        do {
            let registeredUser = try await apiService.register(with: registerDTO)
            self.user = registeredUser
            await databaseService.updateUser(registeredUser)
        } catch {
            print("Register error: \(error.localizedDescription)")
        }
    }
}
