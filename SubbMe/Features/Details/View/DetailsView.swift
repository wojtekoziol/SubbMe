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

    @State private var scale = 0.95
    @State private var opacity = 0.0
    @State private var closeButtonRotation = 0.0

    let subscription: Subscription
    let animation: Namespace.ID

    private let animationDuration = 0.35

    var body: some View {
        @Bindable var vm = vm

        VStack {
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
                    .scaleEffect(scale)
                }
                .opacity(opacity)

                HStack {
                    IconButton(systemImage: "pencil") {
                        vm.showEditScreen(for: subscription)
                    }
                    .opacity(opacity)

                    IconButton(systemImage: "plus") {
                        closeAnimation()
                    }
                    .rotationEffect(.degrees(closeButtonRotation))
                }
                .matchedGeometryEffect(id: "icon-button", in: animation, isSource: false)
                .padding(.horizontal)
            }
        }
        .fontWeight(.semibold)
        .background(.background.opacity(opacity))
        .onAppear {
            openAnimation()
        }
    }

    private func openAnimation() {
        withAnimation(.spring(duration: animationDuration)) {
            scale = 1
            opacity = 1
            closeButtonRotation = 45
        }
    }

    private func closeAnimation() {
        withAnimation(.spring(duration: animationDuration)) {
            scale = 0.95
            opacity = 0
            closeButtonRotation = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            vm.hideDetails()
        }
    }
}

#Preview {
    @Previewable @Namespace var animation

    return DetailsView(subscription: Subscription.example, animation: animation)
        .environment(SubscriptionsViewModel(databaseService: SwiftDataService(container: ModelContainer.preview)))
}
