//
//  Products.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import Foundation

struct ProductResponse: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String?
    let category: String
    let thumbnail: String
    let images: [String]
    
    var discountPrice: Double {
        let discountAmount = price * (discountPercentage / 100)
        return price - discountAmount
    }
    var ratingString: String {
        return String(format: "%.1f", rating)
    }
}
