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
    
    // Favori işlemleri için gerekli bağlantılar
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteItems: [FavoriteItem]
    
    // Izgara Ayarı
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Ürün Sayısı Bilgisi
                HStack {
                    Text("\(products.count) products found")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.horizontal)
                
                // Ürün Listesi (Grid)
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(products) { product in
                        
                        let isFavorite = favoriteItems.contains(where: { $0.productId == product.id })
                        
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            ProductCardView(
                                product: product,
                                isFavorite: isFavorite,
                                onFavoriteToggle: {
                                    toggleFavorite(product: product)
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(title) // Sayfa başlığı kategori adı olacak
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGray6))
    }
    
    // Favori Fonksiyonu (Standart)
    private func toggleFavorite(product: Product) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if let existingFav = favoriteItems.first(where: { $0.productId == product.id }) {
            modelContext.delete(existingFav)
        } else {
            let newFav = FavoriteItem(
                productId: product.id,
                title: product.title,
                price: product.price,
                image: product.thumbnail,
                brand: product.brand,
                desc: product.description,
                rating: product.rating,
                discountPercentage: product.discountPercentage,
                category: product.category
            )
            modelContext.insert(newFav)
        }
    }
}

