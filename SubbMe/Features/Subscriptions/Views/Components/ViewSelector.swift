//
//  ViewSelectorView.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 07/11/2024.
//

import SwiftUI

struct ViewSelector: View {
    let name: String
    let viewType: ViewType

    @Binding var currentViewType: ViewType

    init(name: String, viewType: ViewType, currentViewType: Binding<ViewType>) {
        self.name = name
        self.viewType = viewType
        self._currentViewType = currentViewType
    }

    var isSelected: Bool {
        viewType == currentViewType
    }

    var body: some View {
        Button {
            currentViewType = viewType
        } label: {
            Text(name)
                .font(.title)
                .bold()
                .foregroundStyle(isSelected ? .white : .secondary)
        }
    }
}

#Preview("Selected") {
    ViewSelector(name: "List", viewType: .list, currentViewType: .constant(.list))
}

#Preview("Unselected") {
    ViewSelector(name: "Calendar", viewType: .calendar, currentViewType: .constant(.list))
}
