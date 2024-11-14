//
//  Double+AsPrice.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 13/11/2024.
//

import Foundation

extension Double {
    func asPrice(currencyCode: String) -> String {
        self.formatted(.currency(code: currencyCode))
    }
}
