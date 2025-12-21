//
//  ProductCardView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 11.12.2025.
//

import SwiftUI
import Kingfisher
import SwiftData

struct ProductCardView: View {
    
    let product: Product
    
    @Query private var favoriteItems: [FavoriteItem]
    
    @Environment(\.modelContext) private var modelContext
    
    var isFavorite: Bool {
        FavoriteManager.shared.isFavorite(productId: product.id, items: favoriteItems)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack(alignment: .top) {
                KFImage(URL(string: product.thumbnail))
                    .placeholder {
                        Color.gray.opacity(0.1)
                        
                    }
                    .cacheOriginalImage()
                    .downsampling(size: CGSize(width: 200, height: 200))
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
                    .clipped()
                
                HStack {
                    if product.discountPercentage > 0 {
                        Text("-\(Int(product.discountPercentage))%")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .clipShape(Capsule())
                            .shadow(radius: 2)
                    } else {
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Button {
                        FavoriteManager.shared.toggleFavorite(
                            product: product,
                            context: modelContext,
                            items: favoriteItems
                        )
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.body)
                            .foregroundStyle(isFavorite ? .red : .gray)
                            .padding(6)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                }
                .padding(6)
            }
            .background(Color.white)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.brand ?? "General")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                
                Text(product.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("SecondColor"))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(height: 40, alignment: .top)
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        if product.discountPercentage > 0 {
                            Text("$\(product.price, specifier: "%.2f")")
                                .font(.caption2)
                                .strikethrough()
                                .foregroundStyle(.gray)
                        }
                        Text("$\(product.discountPrice, specifier: "%.2f")")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color("BrandColor"))
                    }
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                        Text(product.ratingString)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
