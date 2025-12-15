//
//  MainTabView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    @State private var selectedTab = 0
    
    @Query private var cartItems: [CartItem]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
                .tag(1)
                .badge(cartItems.isEmpty ? nil : "\(cartItems.count)")
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(2)
        }
        .tint(Color("BrandColor"))
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: CartItem.self, inMemory: true)
}
