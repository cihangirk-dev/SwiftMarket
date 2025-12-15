//
//  SwiftMarketApp.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 9.12.2025.
//

import SwiftUI
import SwiftData

@main
struct SwiftMarketApp: App {
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn {
                    MainTabView()
                        .transition(.opacity)
                }else {
                    LoginView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: isLoggedIn)
        }
        .modelContainer(for: [CartItem.self, FavoriteItem.self])
    }
}
