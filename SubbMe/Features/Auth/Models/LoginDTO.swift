//
//  LoginDTO.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 21/11/2024.
//

import Foundation

struct LoginDTO: Encodable {
    let email: String
    let password: String

    func validate() -> Bool {
        return true
    }
}
