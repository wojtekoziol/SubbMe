//
//  ApiService.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 21/11/2024.
//

import SwiftUI

class ApiService {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    private var token: String?
}

// MARK: - Auth

extension ApiService {
    func register(with registerDTO: RegisterDTO) async throws -> User {
        let body = try encoder.encode(registerDTO)
        let data = try await NetworkService.shared.post(token: nil, endpoint: "auth/register", body: body)
        let user = try decoder.decode(User.self, from: data)
        token = user.token
        return user
    }

    func login(with loginDTO: LoginDTO) async throws -> User {
        let body = try encoder.encode(loginDTO)
        let data = try await NetworkService.shared.post(token: nil, endpoint: "auth/login", body: body)
        let user = try decoder.decode(User.self, from: data)
        token = user.token
        return user
    }
}

// MARK: - Environment

struct ApiServiceKey: EnvironmentKey {
    static var defaultValue = ApiService()
}

extension EnvironmentValues {
    @MainActor
    var apiService: ApiService {
        get { self[ApiServiceKey.self] }
        set { self[ApiServiceKey.self] = newValue }
    }
}
