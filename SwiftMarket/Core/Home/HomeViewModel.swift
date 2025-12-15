//
//  HomeViewModel.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []       // Slider için genel ürünler
    @Published var categories: [Category] = []    // Kategori isimleri
    @Published var searchResults: [Product] = []
    @Published var isSearching = false // Arama yapılıyor mu? (Loading için)
    
    // Kategori Slug'ına göre ürünleri tutan sözlük
    @Published var productsByCategory: [String: [Product]] = [:]
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Slider için (İndirimli olanlar)
    var sliderProducts: [Product] {
        let sortedProducts = products.sorted { $0.discountPercentage > $1.discountPercentage }
        return Array(sortedProducts.prefix(5))
    }
    
    func fetchAllData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Ürünleri ve Kategorileri EŞ ZAMANLI (Parallel) çekiyoruz
            // Sadece 2 istek atılıyor: Biri tüm ürünler, biri kategori listesi.
            async let productsTask = ProductService.shared.fetchProducts()
            async let categoriesTask = ProductService.shared.fetchCategories()
            
            let (fetchedProducts, fetchedCategories) = try await (productsTask, categoriesTask)
            
            self.products = fetchedProducts
            self.categories = fetchedCategories
            
            // 2. HAFIZADA FİLTRELEME (Memory Filtering)
            // Tekrar internete gitmek yerine, elimizdeki ürünleri kategorilere dağıtıyoruz.
            self.organizeProductsByCategory(products: fetchedProducts, categories: fetchedCategories)
            
        } catch {
            self.errorMessage = "Data loading error: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    private func organizeProductsByCategory(products: [Product], categories: [Category]) {
        var tempDict: [String: [Product]] = [:]
        
        for category in categories {
            // Ürünün 'category' özelliği ile Kategori'nin 'slug' özelliği eşleşiyor mu?
            let filteredProducts = products.filter { $0.category == category.slug }
            
            // Eğer o kategoride ürün varsa listeye ekle
            if !filteredProducts.isEmpty {
                tempDict[category.slug] = filteredProducts
            }
        }
        
        self.productsByCategory = tempDict
    }
    
    func performSearch(query: String) async {
        // Boş arama yapılmasın
        guard query.count > 1 else {
            self.searchResults = []
            return
        }

        isSearching = true

        do {
            // Servisteki yeni fonksiyonu çağırıyoruz
            let results = try await ProductService.shared.searchProducts(query: query)
            self.searchResults = results
        } catch {
            print("Search error: \(error.localizedDescription)")
            self.searchResults = []
        }

        isSearching = false
    }
}
