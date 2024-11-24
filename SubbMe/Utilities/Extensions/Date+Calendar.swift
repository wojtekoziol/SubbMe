//
//  Date+Calendar.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 24/11/2024.
//

import Foundation

extension Date {
    var endOfMonth: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }

    var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }

    var firstDayOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }

    var firstWeekdayOfMonth: Int {
        Calendar.current.component(.weekday, from: firstDayOfMonth)
    }

    var calendarDisplayDays: [Date] {
        var days = [Date]()
        let calendar = Calendar.current

        for i in 0..<firstWeekdayOfMonth - 1 {
            let day = calendar.date(byAdding: .day, value: -(i + 1), to: firstDayOfMonth)!
            days.append(day)
        }

        for i in 0..<numberOfDaysInMonth {
            let day = calendar.date(byAdding: .day, value: i, to: firstDayOfMonth)!
            days.append(day)
        }

        return days.sorted(by: <)
    }

    var nextMonth: Date {
        Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }

    var previousMonth: Date {
        Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }

    func isSameMonth(as date: Date) -> Bool {
        let calendar = Calendar.current
        let month1 = calendar.component(.month, from: self)
        let month2 = calendar.component(.month, from: date)
        return month1 == month2
    }
}
