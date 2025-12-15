//
//  HomeViewModel.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [Category] = []
    @Published var searchResults: [Product] = []
    @Published var isSearching = false
    
    @Published var productsByCategory: [String: [Product]] = [:]
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var sliderProducts: [Product] {
        let sortedProducts = products.sorted { $0.discountPercentage > $1.discountPercentage }
        return Array(sortedProducts.prefix(5))
    }
    
    func fetchAllData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let productsTask = ProductService.shared.fetchProducts()
            async let categoriesTask = ProductService.shared.fetchCategories()
            
            let (fetchedProducts, fetchedCategories) = try await (productsTask, categoriesTask)
            
            self.products = fetchedProducts
            self.categories = fetchedCategories
            
            self.organizeProductsByCategory(products: fetchedProducts, categories: fetchedCategories)
            
        } catch {
            self.errorMessage = "Data loading error: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    private func organizeProductsByCategory(products: [Product], categories: [Category]) {
        var tempDict: [String: [Product]] = [:]
        
        for category in categories {
            let filteredProducts = products.filter { $0.category == category.slug }
            
            if !filteredProducts.isEmpty {
                tempDict[category.slug] = filteredProducts
            }
        }
        
        self.productsByCategory = tempDict
    }
    
    func performSearch(query: String) async {
        guard query.count > 1 else {
            self.searchResults = []
            return
        }

        isSearching = true

        do {
            let results = try await ProductService.shared.searchProducts(query: query)
            self.searchResults = results
        } catch {
            print("Search error: \(error.localizedDescription)")
            self.searchResults = []
        }

        isSearching = false
    }
}
