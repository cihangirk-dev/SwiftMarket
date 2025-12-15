//
//  ProductService.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import Foundation

class ProductService {
    
    static let shared = ProductService()
    private init() {}
    
    func fetchProducts() async throws -> [Product] {
        
        guard let url = URL(string: "https://dummyjson.com/products?limit=0") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(ProductResponse.self, from: data)
        return result.products
    }
    
    func fetchCategories() async throws -> [Category] {
        guard let url = URL(string: "https://dummyjson.com/products/categories") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([Category].self, from: data)
    }

    func fetchProductsByCategory(categorySlug: String) async throws -> [Product] {
        
        guard let url = URL(string: "https://dummyjson.com/products/category/\(categorySlug)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(ProductResponse.self, from: data)
        return result.products
    }
    
    func searchProducts(query: String) async throws -> [Product] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: "https://dummyjson.com/products/search?q=\(encodedQuery)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(ProductResponse.self, from: data)
        return result.products
    }
}
