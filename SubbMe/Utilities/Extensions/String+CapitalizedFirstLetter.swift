//
//  String+CapitalizedFirstLetter.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 11/11/2024.
//

import Foundation

extension String {
    func capitalizedFirstLetter() -> String {
        prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizedFirstLetter()
    }
}
