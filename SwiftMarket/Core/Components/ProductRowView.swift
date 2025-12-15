//
//  ProductRowView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 12.12.2025.
//


import SwiftUI
import SwiftData
import Kingfisher

struct ProductRowView: View {
    let title: String
    let products: [Product]
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteItems: [FavoriteItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // --- BAŞLIK ALANI ---
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("SecondColor"))
                
                Spacer()
                
                NavigationLink {
                    CategoryDetailView(title: title, products: products)
                } label: {
                    Text("See All")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("BrandColor"))
                }
            }
            .padding(.horizontal)
            
            // --- YATAY LİSTE (RAF) ---
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(products) { product in
                        
                        let isFavorite = favoriteItems.contains(where: { $0.productId == product.id })
                        
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            // Burada zaten güncellediğimiz Kingfisher'lı CardView'ı kullanıyoruz
                            ProductCardView(
                                product: product,
                                isFavorite: isFavorite,
                                onFavoriteToggle: {
                                    toggleFavorite(product: product)
                                }
                            )
                            .frame(width: UIScreen.main.bounds.width * 0.4)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
    }
    
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
