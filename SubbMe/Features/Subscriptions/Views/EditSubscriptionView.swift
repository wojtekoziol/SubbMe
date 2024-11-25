//
//  EditSubscriptionView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 11/11/2024.
//

import Factory
import SwiftUI
import SwiftData

struct EditSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SubscriptionsViewModel.self) private var subscriptionsViewModel
    @State private var vm: EditSubscriptionViewModel

    init(subscription: Subscription?) {
        self._vm = State(wrappedValue: EditSubscriptionViewModel(subscription: subscription))
    }

    var title: String {
        vm.isNew ? "New Subscription" : "Edit Subscription"
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $vm.name)

                Picker("Subscription Type", selection: $vm.type) {
                    ForEach(SubscriptionType.allCases, id: \.self) {
                        Text(String(describing: $0))
                    }
                }

                HStack {
                    TextField("Price", text: $vm.price)
                        .keyboardType(.numberPad)

                    Picker("Currency", selection: $vm.currencyCode) {
                        ForEach(Constants.availableCurrencies, id: \.self) {
                            Text($0)
                        }
                    }
                    .labelsHidden()
                }

                Section {
                    DatePicker("Date Started", selection: $vm.dateStarted, displayedComponents: [.date])

                    Toggle(isOn: $vm.dateEndingEnabled) {
                        Text("Has end date")
                    }

                    if vm.dateEndingEnabled {
                        DatePicker("Date Ending", selection: $vm.dateEnding, displayedComponents: [.date])
                    }
                }

                Section {
                    Toggle(isOn: $vm.reminderEnabled) {
                        Text("Remind me")
                    }

                    if vm.reminderEnabled {
                        Stepper("^[\(vm.reminderDays) day](inflect: true) before", value: $vm.reminderDays, in: 1...14)
                    }
                }

                Section {
                    TextField("Website URL", text: $vm.websiteURL)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                Section {
                    Button("Save") {
                        Task {
                            await vm.save()
                            await subscriptionsViewModel.fetchSubscriptions()
                            dismiss()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!vm.isFormValid)

                    if !vm.isNew {
                        Button("Delete", role: .destructive) {
                            vm.showDeleteAlert()
                        }
                    }
                }
            }
            .animation(.default, value: vm.dateEndingEnabled)
            .animation(.default, value: vm.reminderEnabled)
            .navigationTitle(title.localizedCapitalized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .alert("Delete?", isPresented: $vm.showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }

                Button("Delete", role: .destructive) {
                    Task {
                        await vm.delete()
                        await subscriptionsViewModel.fetchSubscriptions()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    Container.shared.preview()
    return EditSubscriptionView(subscription: Subscription.example)
        .environment(SubscriptionsViewModel())
}
