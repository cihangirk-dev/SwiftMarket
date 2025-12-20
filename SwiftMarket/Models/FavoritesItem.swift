//
//  FavoriteItem.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import Foundation
import SwiftData

@Model
class FavoriteItem {
    @Attribute(.unique) var productId: Int
    var title: String
    var price: Double
    var thumbnail: String
    var images: [String]
    var brand: String?
    var desc: String
    var rating: Double
    var discountPercentage: Double
    var category: String
    
    init(productId: Int, title: String, price: Double, thumbnail: String, images: [String], brand: String?, desc: String, rating: Double, discountPercentage: Double, category: String) {
        self.productId = productId
        self.title = title
        self.price = price
        self.thumbnail = thumbnail
        self.images = images
        self.brand = brand
        self.desc = desc
        self.rating = rating
        self.discountPercentage = discountPercentage
        self.category = category
    }
}
