//
//  DetailsView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 13/11/2024.
//

import SwiftUI
import SwiftData

struct DetailsView: View {
    @Environment(\.databaseService) private var databaseService
    @Environment(SubscriptionsViewModel.self) private var vm

    let subscription: Subscription
    let animation: Namespace.ID

    var body: some View {
        @Bindable var vm = vm

        ZStack(alignment: .topTrailing) {
            ScrollView {
                LazyVStack(spacing: 40) {
                    Circle()
                        .frame(width: 80)

                    VStack {
                        HStack {
                            Text(subscription.name)
                                .font(.title)
                                .bold()

                            PriceTagView(price: subscription.price, currencyCode: subscription.currencyCode)
                        }

                        Text("Next bill: ")
                            .foregroundStyle(.secondary)
                        + Text(subscription.nextBill.formattedString())
                    }

                    VStack {
                        DetailRow("Period") {
                            HStack {
                                Circle()
                                    .fill(subscription.isActive ? .green : .red)
                                    .frame(width: 7.5)

                                Text(String(describing: subscription.type))
                            }
                        }

                        DetailRow("Date Started") {
                            Text(subscription.dateStarted.formattedString())
                        }

                        DetailRow("Date Ending") {
                            Text(subscription.dateEnding.formattedString())
                        }

                        DetailRow("Website") {
                            if let urlString = subscription.websiteURL, let url = URL(string: urlString) {
                                Link(destination: url) {
                                    Label(urlString, systemImage: "link")
                                }
                            } else {
                                Text("-")
                            }
                        }
                    }
                }
                .padding()
                .padding(.top, 50)
            }

            HStack {
                IconButton(systemImage: "pencil") {
                    vm.showEditScreen(for: subscription)
                }

                IconButton(systemImage: "xmark") {
                    vm.hideDetails()
                }
                .matchedGeometryEffect(id: "icon-button", in: animation)
            }
            .padding(.horizontal)
        }
        .fontWeight(.semibold)
        .background(.background)
    }
}

#Preview {
    @Previewable @Namespace var animation

    return DetailsView(subscription: Subscription.example, animation: animation)
        .environment(SubscriptionsViewModel(databaseService: SwiftDataService(container: ModelContainer.preview)))
}