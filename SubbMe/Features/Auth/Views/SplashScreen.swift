//
//  SplashScreen.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 23/11/2024.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        Image(systemName: "creditcard")
        .font(.largeTitle)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.launchScreenBackground)
    }
}

#Preview {
    SplashScreen()
}
