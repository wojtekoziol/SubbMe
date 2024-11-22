//
//  ApiService.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 21/11/2024.
//

import SwiftUI

class ApiService: ApiServiceProtocol {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private var token: String?

    // MARK: - Auth

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

    // MARK: - Subscriptions

    func fetchSubscriptions() async throws -> [Subscription] {
        let data = try await NetworkService.shared.get(token: token, endpoint: "subscription")
        return try decoder.decode([Subscription].self, from: data)
    }

    func createSubscription(_ subscription: Subscription) async throws -> Subscription {
        let body = try encoder.encode(subscription)
        let data = try await NetworkService.shared.post(token: token, endpoint: "subscription", body: body)
        return try decoder.decode(Subscription.self, from: data)
    }

    func updateSubscription(_ subscription: Subscription) async throws -> Subscription {
        guard let id = subscription.id else { throw NetworkError.invalidData }
        let body = try encoder.encode(subscription)
        let data = try await NetworkService.shared.put(token: token, endpoint: "subscription/\(id)", body: body)
        return try decoder.decode(Subscription.self, from: data)
    }
}
