//
//  FavoriteManager.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 20.12.2025.
//

import Foundation
import SwiftUI
import SwiftData

class FavoriteManager {
    static let shared = FavoriteManager()
    private init() {}
    
    func toggleFavorite(product: Product, context: ModelContext, items: [FavoriteItem]) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if let existingFav = items.first(where: { $0.productId == product.id }) {
            context.delete(existingFav)
        }else {
            let newFav = FavoriteItem(
                productId: product.id,
                title: product.title,
                price: product.price,
                thumbnail: product.thumbnail,
                images: product.images,
                brand: product.brand,
                desc: product.description,
                rating: product.rating,
                discountPercentage: product.discountPercentage,
                category: product.category
                
            )
            context.insert(newFav)
        }
    }
    
    func isFavorite(productId: Int, items: [FavoriteItem]) -> Bool {
        return items.contains(where: { $0.productId == productId })
    }
}
