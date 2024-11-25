//
//  NotificationService.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 25/11/2024.
//

import Foundation
import UserNotifications

class NotificationService {
    private init() { }

    static let shared = NotificationService()

    private var authorized = false

    private func askForPermission() async {
        do {
            authorized = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .provisional])
        } catch {
            print(error.localizedDescription)
        }
    }

    func scheduleAll(_ subscriptions: [Subscription]) async {
        guard subscriptions.count > 0 else { return }

        await askForPermission()
        guard authorized else { return }

        cancelAll()

        for subscription in subscriptions {
            schedule(for: subscription)
        }
    }

    private func schedule(for subscription: Subscription) {
        guard let id = subscription.id else { return }
        guard let date = subscription.reminderDate else { return }

        var dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        dateComponents.hour = 9

        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = ""

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: String(id), content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    private func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
