//
//  SubbMeWidget.swift
//  SubbMeWidget
//
//  Created by Wojciech Kozioł on 26/11/2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TodayEntry {
        TodayEntry(date: Date(), subscriptions: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayEntry) -> ()) {
        let entry = TodayEntry(date: Date(), subscriptions: [.example])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let date = Calendar.current.startOfDay(for: Date())
        let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: date)!

        var subscriptions: [Subscription] = []
        if let userDefaults = UserDefaults(suiteName: "group.com.wojciechkoziol.SubbMe"),
            let data = userDefaults.data(forKey: date.asKey()) {
            if let decoded = try? JSONDecoder().decode([Subscription].self, from: data) {
                subscriptions = decoded
            }
        }

        let entry = TodayEntry(date: nextUpdate, subscriptions: subscriptions)

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct TodayEntry: TimelineEntry {
    let date: Date
    let subscriptions: [Subscription]
}

struct SubbMeWidgetEntryView : View {
    var entry: Provider.Entry

    let displayedSubscriptions: [Subscription]

    init(entry: Provider.Entry) {
        self.entry = entry
        self.displayedSubscriptions = Array(entry.subscriptions.prefix(3))
    }

    var body: some View {
        VStack {
            Spacer()

            if displayedSubscriptions.isEmpty {
                Text("No subscriptions for today 🚀")
                    .font(.callout)
                    .multilineTextAlignment(.center)
            }

            ForEach(displayedSubscriptions) { subscription in
                HStack(spacing: 0) {
                    Text(subscription.name)

                    Spacer()

                    Text(subscription.price.asPrice(currencyCode: subscription.currencyCode))
                        .foregroundStyle(.secondary)
                }
                .font(.caption2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(.quaternary)
                .clipShape(.capsule)
            }

            Spacer()

            Text(entry.date, style: .date)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

struct SubbMeWidget: Widget {
    let kind: String = "TodaySubscriptions"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SubbMeWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SubbMeWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Today's subscriptions")
        .description("Check today's renewing subscriptions.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    SubbMeWidget()
} timeline: {
    TodayEntry(date: .now, subscriptions: [.example, .example, .example])
    TodayEntry(date: .now, subscriptions: [])
}
