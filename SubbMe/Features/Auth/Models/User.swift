//
//  User.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 21/11/2024.
//

import Foundation
import SwiftData

@Model
class User: Decodable {
    enum CodingKeys: String, CodingKey {
        case email
        case firstName
        case lastName
        case token
    }

    var email: String
    var firstName: String
    var lastName: String
    @Attribute(.ephemeral) var token: String?

    init(email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        token = try container.decode(String.self, forKey: .token)
    }

    static let example = User(email: "user@example.com", firstName: "John", lastName: "Doe")
}
