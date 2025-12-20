//
//  FavoritesViewModel.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 11.12.2025.
//

import Foundation
import SwiftData
import SwiftUI

class FavoritesViewModel: ObservableObject {
    
    func deleteFavorite(_ item: FavoriteItem, context: ModelContext) {
        context.delete(item)
    }
    
    func createProduct(from item: FavoriteItem) -> Product {
        return Product(
            id: item.productId,
            title: item.title,
            description: item.desc,
            price: item.price,
            discountPercentage: item.discountPercentage,
            rating: item.rating,
            stock: 0,
            brand: item.brand,
            category: item.category,
            thumbnail: item.thumbnail,
            images: item.images
        )
    }
}
