//
//  Date+FormattedString.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 13/11/2024.
//

import Foundation

extension Date {
    func formattedString(style: DateFormatter.Style = .long) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    func asKey() -> String {
        self.formatted(.dateTime.day().month().year())
    }
}

extension Date? {
    func formattedString(style: DateFormatter.Style = .long) -> String {
        guard let date = self else { return "-" }
        return date.formattedString(style: style)
    }
}
