//
//  Keychain.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 23/11/2024.
//

import Foundation
import KeychainSwift

struct Keychain {
    static let shared = Keychain()

    private let keychain: KeychainSwift = KeychainSwift()

    private let emailKey: String = "email"
    private let passwordKey: String = "password"

    private init() { }

    func saveCredentials(email: String, password: String) {
        keychain.set(email, forKey: emailKey)
        keychain.set(password, forKey: passwordKey)
    }

    func getCredentials() -> (email: String, password: String)? {
        guard let email = keychain.get(emailKey), let password = keychain.get(passwordKey) else { return nil }
        return (email, password)
    }
}
