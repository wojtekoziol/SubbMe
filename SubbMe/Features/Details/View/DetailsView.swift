//
//  DetailsView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 13/11/2024.
//

import Factory
import SwiftUI
import SwiftData

struct DetailsView: View {
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
                VStack(spacing: 40) {
                    Image(systemName: "creditcard")
                        .font(.largeTitle)
                        .padding(25)
                        .background(.regularMaterial)
                        .clipShape(.circle)

                    VStack {
                        HStack {
                            Text(subscription.name)
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)
                                .lineLimit(2)

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
                                    .fill(subscription.isActive ? .darkGreen : .red)
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

                        DetailRow("Remind me") {
                            if let reminderDays = subscription.reminderDays {
                                Text("^[\(reminderDays) day](inflect: true) before")
                            } else {
                                Text("-")
                            }
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

                    Spacer()
                }
                .padding()
                .padding(.top, 50)
                .scaleEffect(scale)
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
        .frame(maxHeight: .infinity)
        .background(.background.opacity(opacity))
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height > 0 {
                    closeAnimation()
                }
            }
        )
        .onAppear {
            openAnimation()
        }
        .onChange(of: vm.subscriptions) { oldValue, newValue in
            if !vm.subscriptions.contains(where: { $0.id == subscription.id }) { closeAnimation() }
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

    Container.shared.preview()

    return DetailsView(subscription: Subscription.example, animation: animation)
        .environment(SubscriptionsViewModel())
}
