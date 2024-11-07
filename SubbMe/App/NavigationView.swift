//
//  NavigationView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import SwiftData
import SwiftUI

struct NavigationView: View {
    @Environment(\.databaseService) private var databaseService

    var body: some View {
        SubscriptionsListView(databaseService: SwiftDataService())
    }
}

#Preview {
    NavigationView()
}
