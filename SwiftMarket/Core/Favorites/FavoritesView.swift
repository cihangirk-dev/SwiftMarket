//
//  FavoritesView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    
    @StateObject private var viewModel = FavoritesViewModel()
    @Query(sort: \FavoriteItem.title) private var favoriteItems: [FavoriteItem]
    @Environment(\.modelContext) private var modelContext
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if favoriteItems.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 80))
                            .foregroundStyle(.gray.opacity(0.5))
                        Text("No favorites yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondColor"))
                        Text("You can add items here by tapping the heart icon on products.")
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 100)
                    
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(favoriteItems) { item in
                            
                            let product = viewModel.createProduct(from: item)
                            
                            NavigationLink {
                                ProductDetailView(product: product)
                            } label: {
                                ProductCardView(product: product)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Favorites")
            .background(Color(.systemGray6))
        }
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: FavoriteItem.self)
}
