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
        let request = NetworkRequest(endpoint: "auth/register", method: .post, token: nil, body: body)
        let data = try await NetworkService.shared.performRequest(request)
        let user = try decoder.decode(User.self, from: data)
        token = user.token
        return user
    }

    func login(with loginDTO: LoginDTO) async throws -> User {
        let body = try encoder.encode(loginDTO)
        let request = NetworkRequest(endpoint: "auth/login", method: .post, token: nil, body: body)
        let data = try await NetworkService.shared.performRequest(request)
        let user = try decoder.decode(User.self, from: data)
        token = user.token
        return user
    }

    // MARK: - Subscriptions

    func fetchSubscriptions() async throws -> [Subscription] {
        let request = NetworkRequest(endpoint: "subscription", method: .get, token: token, body: nil)
        let data = try await NetworkService.shared.performRequest(request)
        return try decoder.decode([Subscription].self, from: data)
    }

    func createSubscription(_ subscription: Subscription) async throws -> Subscription {
        let body = try encoder.encode(subscription)
        let request = NetworkRequest(endpoint: "subscription", method: .post, token: token, body: body)
        let data = try await NetworkService.shared.performRequest(request)
        return try decoder.decode(Subscription.self, from: data)
    }

    func updateSubscription(_ subscription: Subscription) async throws -> Subscription {
        guard let id = subscription.id else { throw NetworkError.invalidData }
        let body = try encoder.encode(subscription)
        let request = NetworkRequest(endpoint: "subscription/\(id)", method: .put, token: token, body: body)
        let data = try await NetworkService.shared.performRequest(request)
        return try decoder.decode(Subscription.self, from: data)
    }

    func deleteSubscription(_ subscription: Subscription) async throws {
        guard let id = subscription.id else { throw NetworkError.invalidData }
        let request = NetworkRequest(endpoint: "subscription/\(id)", method: .delete, token: token, body: nil)
        let _ = try await NetworkService.shared.performRequest(request)
    }
}
