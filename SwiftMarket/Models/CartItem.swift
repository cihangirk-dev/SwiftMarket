//
//  CartItem.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import Foundation
import SwiftData

@Model
class CartItem {
    @Attribute(.unique) var productId: Int
    var title: String
    var price: Double
    var quantity: Int
    var image: String
    var brand: String?
    
    init(productId: Int, title: String, price: Double, quantity: Int, image: String, brand: String?) {
        self.productId = productId
        self.title = title
        self.price = price
        self.quantity = quantity
        self.image = image
        self.brand = brand
    }
    
    var totalValue: Double {
        return price * Double(quantity)
    }
}
