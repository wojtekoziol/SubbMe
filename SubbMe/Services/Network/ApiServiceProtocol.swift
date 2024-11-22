//
//  ApiServiceProtocol.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 22/11/2024.
//

import Foundation

protocol ApiServiceProtocol {
    func register(with registerDTO: RegisterDTO) async throws -> User
    func login(with loginDTO: LoginDTO) async throws -> User
    func fetchSubscriptions() async throws -> [Subscription]
    func createSubscription(_ subscription: Subscription) async throws -> Subscription
    func updateSubscription(_ subscription: Subscription) async throws -> Subscription
}

// MARK: - Mock

class MockApiService: ApiServiceProtocol {
    func register(with registerDTO: RegisterDTO) async throws -> User { User.example }
    func login(with loginDTO: LoginDTO) async throws -> User { User.example }
    func fetchSubscriptions() async throws -> [Subscription] { [Subscription.example] }
    func createSubscription(_ subscription: Subscription) async throws -> Subscription { Subscription.example }
    func updateSubscription(_ subscription: Subscription) async throws -> Subscription { Subscription.example }
}
