//
//  AuthViewModel.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 21/11/2024.
//

import Foundation

@Observable
class AuthViewModel {
    private let databaseService: DatabaseService
    private let apiService: ApiService

    private(set) var user: User?

    var email = ""
    var password = ""
    var firstName = ""
    var lastName = ""

    init(databaseService: DatabaseService, apiService: ApiService) {
        self.databaseService = databaseService
        self.apiService = apiService
    }

    private func getUserFromDatabase() async {
        user = await databaseService.fetchUser()
    }

    func login() async {
        let loginDTO = LoginDTO(email: email, password: password)
        guard loginDTO.validate() else { return }

        do {
            let loggedUser = try await apiService.login(with: loginDTO)
            self.user = loggedUser
            await databaseService.addUser(loggedUser)
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
            await databaseService.addUser(registeredUser)
        } catch {
            print("Register error: \(error.localizedDescription)")
        }
    }
}
