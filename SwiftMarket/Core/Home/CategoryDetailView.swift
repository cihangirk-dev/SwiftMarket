//
//  CategoryDetailView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 12.12.2025.
//

import SwiftUI
import SwiftData

struct CategoryDetailView: View {
    
    let title: String
    let products: [Product]
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteItems: [FavoriteItem]
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                HStack {
                    Text("\(products.count) products found")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(products) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            ProductCardView(product: product)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGray6))
    }
}

