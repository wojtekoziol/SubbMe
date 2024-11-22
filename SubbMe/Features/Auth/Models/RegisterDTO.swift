//
//  RegisterDTP.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 21/11/2024.
//

import Foundation

struct RegisterDTO: Encodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String

    func validate() -> Bool {
        return true
    }
}
