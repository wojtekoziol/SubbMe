//
//  EditSubscriptionViewModel.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 11/11/2024.
//

import Foundation
import SuperValidator

@Observable
class EditSubscriptionViewModel {
    let databaseService: DatabaseService
    let subscription: Subscription

    var name = ""
    var type = SubscriptionType.monthly
    var price = ""
    var currencyCode = "EUR"
    var dateStarted = Date()
    var dateEndingEnabled = false
    var dateEnding = Date()
    var websiteURL = ""

    var isNew: Bool
    var showingDeleteAlert = false

    init(databaseService: DatabaseService, subscription: Subscription?) {
        self.databaseService = databaseService
        self.subscription = subscription ?? Subscription()
        self.isNew = subscription == nil

        // Update fields with subscriptions properties
        self.name = self.subscription.name
        self.type = self.subscription.type
        self.price = "\(self.subscription.price)"
        self.currencyCode = self.subscription.currencyCode
        self.dateStarted = self.subscription.dateStarted
        self.dateEndingEnabled = self.subscription.dateEnding != nil
        self.dateEnding = self.subscription.dateEnding ?? Date()
        self.websiteURL = self.subscription.websiteURL ?? ""
    }

    func save() {
        subscription.name = name
        subscription.type = type
        subscription.price = Double(price) ?? 0
        subscription.currencyCode = currencyCode
        subscription.dateEndingAsInterval = dateStarted.timeIntervalSince1970
        subscription.dateEndingAsInterval = dateEndingEnabled ? dateEnding.timeIntervalSince1970 : nil
        subscription.websiteURL = websiteURL

        Task {
            if isNew {
                await databaseService.addSubscription(subscription)
                self.isNew = false
            }
        }
    }

    func showDeleteAlert() {
        showingDeleteAlert = true
    }

    func delete() {
        guard showingDeleteAlert else { return }

        Task {
            await databaseService.deleteSubscription(subscription)
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
