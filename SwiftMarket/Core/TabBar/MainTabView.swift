//
//  MainTabView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    // Hangi tab seçili
    @State private var selectedTab = 0
    
    // Sepet sayısını rozet (badge) olarak göstermek için
    @Query private var cartItems: [CartItem]
    
    var body: some View {
        // Standart Native TabView
        TabView(selection: $selectedTab) {
            
            // 1. ANASAYFA
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            // 2. SEPET
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
                .tag(1)
                // Kırmızı bildirim balonu (Native özellik)
                .badge(cartItems.isEmpty ? nil : "\(cartItems.count)")
            
            // 3. FAVORİLER
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(2)
        }
        // Seçili olan ikonun rengi (Marka Rengi)
        .tint(Color("BrandColor"))
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: CartItem.self, inMemory: true)
}
