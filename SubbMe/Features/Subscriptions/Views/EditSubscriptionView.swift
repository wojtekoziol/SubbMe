//
//  EditSubscriptionView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 11/11/2024.
//

import SwiftUI
import SwiftData

struct EditSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SubscriptionsViewModel.self) private var subscriptionsViewModel
    @State private var vm: EditSubscriptionViewModel

    init(databaseService: DatabaseService, subscription: Subscription?) {
        self._vm = State(wrappedValue: EditSubscriptionViewModel(databaseService: databaseService, subscription: subscription))
    }

    var title: String {
        vm.isNew ? "New Subscription" : "Edit Subscription"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    TextField("Name", text: $vm.name)

                    HStack {
                        Text("Subscription Type")

                        Spacer()

                        Picker("Subscription Type", selection: $vm.type) {
                            ForEach(SubscriptionType.allCases, id: \.self) {
                                Text(String(describing: $0))
                            }
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
                    }

                    DatePicker("Date Started", selection: $vm.dateStarted, displayedComponents: [.date])

                    Toggle(isOn: $vm.dateEndingEnabled) {
                        Text("Has end date")
                    }

                    if vm.dateEndingEnabled {
                        DatePicker("Date Ending", selection: $vm.dateEnding, displayedComponents: [.date])
                    }

                    TextField("Website URL", text: $vm.websiteURL)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    Button("Save") {
                        vm.save()
                        subscriptionsViewModel.fetchSubscriptions()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!vm.isFormValid)

                    if !vm.isNew {
                        Button("Delete", role: .destructive) {
                            vm.showDeleteAlert()
                        }
                    }
                }
                .padding()
                .animation(.default, value: vm.dateEndingEnabled)
            }
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
                    vm.delete()
                    subscriptionsViewModel.fetchSubscriptions()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    let databaseService = SwiftDataService(container: ModelContainer.preview)
    return EditSubscriptionView(databaseService: databaseService, subscription: Subscription.example)
        .environment(SubscriptionsViewModel(databaseService: databaseService))
}
