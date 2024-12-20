//
//  EditSubscriptionViewModel.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 11/11/2024.
//

import Factory
import Foundation
import SuperValidator

@Observable
class EditSubscriptionViewModel {
    @ObservationIgnored
    @Injected(\.databaseService) private var databaseService

    @ObservationIgnored
    @Injected(\.apiService) private var apiService

    let subscription: Subscription

    var name = ""
    var type = SubscriptionType.monthly
    var price = ""
    var currencyCode = "EUR"
    var dateStarted = Date()
    var dateEnding = Date()
    var websiteURL = ""

    var dateEndingEnabled = false
    var reminderEnabled = false
    var reminderDays = 1

    var isNew: Bool
    var showingDeleteAlert = false

    init(subscription: Subscription?) {
        self.subscription = subscription ?? Subscription()
        self.isNew = subscription == nil

        // Update fields with subscriptions properties
        self.name = self.subscription.name
        self.type = self.subscription.type
        self.price = "\(self.subscription.price)"
        self.currencyCode = self.subscription.currencyCode
        self.dateStarted = self.subscription.dateStarted
        self.dateEnding = self.subscription.dateEnding ?? Date()
        self.websiteURL = self.subscription.websiteURL ?? ""
        self.dateEndingEnabled = self.subscription.dateEnding != nil
        self.reminderEnabled = self.subscription.reminderDays != nil
        self.reminderDays = self.subscription.reminderDays ?? 1
    }

    func save() async {
        if isNew {
            await createSubscription()
        } else {
            await updateSubscription()
        }
    }

    private func updateSubscription() async {
        let subBuf = subscription.copy() as! Subscription
        do {
            subscription.name = name
            subscription.type = type
            subscription.price = Double(price) ?? 0
            subscription.currencyCode = currencyCode
            subscription.dateStartedAsInterval = dateStarted.timeIntervalSince1970
            subscription.dateEndingAsInterval = dateEndingEnabled ? dateEnding.timeIntervalSince1970 : nil
            subscription.websiteURL = websiteURL
            subscription.reminderDays = reminderEnabled ? reminderDays : nil

            let _ = try await apiService.updateSubscription(subscription)
        } catch {
            print("Error updating subscription: \(error.localizedDescription)")
            subscription.name = subBuf.name
            subscription.type = subBuf.type
            subscription.price = subBuf.price
            subscription.currencyCode = subBuf.currencyCode
            subscription.dateStartedAsInterval = subBuf.dateStartedAsInterval
            subscription.dateEndingAsInterval = subBuf.dateEndingAsInterval
            subscription.websiteURL = subBuf.websiteURL
            subscription.reminderDays = subBuf.reminderDays
        }
    }

    private func createSubscription() async {
        subscription.name = name
        subscription.type = type
        subscription.price = Double(price) ?? 0
        subscription.currencyCode = currencyCode
        subscription.dateStartedAsInterval = dateStarted.timeIntervalSince1970
        subscription.dateEndingAsInterval = dateEndingEnabled ? dateEnding.timeIntervalSince1970 : nil
        subscription.websiteURL = websiteURL
        subscription.reminderDays = reminderEnabled ? reminderDays : nil

        do {
            let newSubscription = try await apiService.createSubscription(subscription)
            await databaseService.addSubscription(newSubscription)
            self.isNew = false
        } catch {
            print("Error creating subscription: \(error.localizedDescription)")
        }
    }

    func showDeleteAlert() {
        showingDeleteAlert = true
    }

    func delete() async {
        do {
            try await apiService.deleteSubscription(subscription)
            await databaseService.deleteSubscription(subscription)
        } catch {
            print("Error deleting subscription: \(error.localizedDescription)")
        }
    }

    var isFormValid: Bool {
        return isUrlValid
    }

    private var isUrlValid: Bool {
        let validator = SuperValidator.shared
        let options = SuperValidator.Option.URL.init(
            protocols: ["https", "http"],
            requireProtocol: true,
            requireValidProtocol: true
        )

        let urlValidatorResult = validator.validateURL(websiteURL, options: options)
        let isUrlValid = (try? urlValidatorResult.get()) != nil

        return websiteURL.isEmpty || isUrlValid
    }
}
