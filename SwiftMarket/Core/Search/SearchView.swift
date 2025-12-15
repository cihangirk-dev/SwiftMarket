//
//  SearchView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 12.12.2025.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @FocusState private var isFocused: Bool
    
    @State private var searchText = ""
    @State private var selectedCategory: Category? // Kategori seçimi geri geldi
    
    // API isteğini geciktirmek için (Debounce)
    @State private var searchTask: Task<Void, Never>?
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteItems: [FavoriteItem]
    
    // Kategori butonları için grid
    private let categoryColumns = [
        GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 10)
    ]
    
    // Ürünler için grid
    private let productColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // --- 1. ARAMA HEADER ---
            HStack(spacing: 12) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3).foregroundStyle(.gray)
                }
                
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.gray)
                    
                    TextField("Search", text: $searchText)
                        .focused($isFocused)
                        .submitLabel(.search)
                        .onChange(of: searchText) { oldValue, newValue in
                            // Yazı yazılmaya başlarsa kategori seçimini iptal et
                            if !newValue.isEmpty { selectedCategory = nil }
                            
                            // API Araması (Debounce)
                            searchTask?.cancel()
                            searchTask = Task {
                                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sn bekle
                                if !Task.isCancelled && !newValue.isEmpty {
                                    await viewModel.performSearch(query: newValue)
                                }
                            }
                        }
                    
                    // Temizleme Butonu
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                            viewModel.searchResults = []
                        } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 2, y: 2)
            
            // --- 2. İÇERİK ALANI ---
            ScrollView {
                VStack(spacing: 20) {
                    
                    // DURUM A: Hiçbir şey seçili değil -> Kategorileri Göster
                    if searchText.isEmpty && selectedCategory == nil {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Categories")
                                .font(.headline)
                                .foregroundStyle(.gray)
                            
                            LazyVGrid(columns: categoryColumns, spacing: 12) {
                                ForEach(viewModel.categories) { category in
                                    Button {
                                        // Kategori seçince klavyeyi kapat ve seçimi yap
                                        selectedCategory = category
                                        isFocused = false
                                        searchText = "" // Yazıyı temizle
                                    } label: {
                                        Text(category.name.replacingOccurrences(of: "-", with: " ").capitalized)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundStyle(Color("SecondColor"))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 10)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.white)
                                            .clipShape(Capsule())
                                            .overlay(
                                                Capsule().stroke(Color(.systemGray5), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        }
                        .padding()
                        
                    } else {
                        // DURUM B ve C: Bir sonuç gösterilecek (Ya Arama ya Kategori)
                        
                        // Hangi ürün listesini göstereceğiz?
                        let productsToShow: [Product] = {
                            if let category = selectedCategory {
                                // Kategori seçiliyse hafızadan getir (HIZLI)
                                return viewModel.productsByCategory[category.slug] ?? []
                            } else {
                                // Yazı yazıldıysa API sonuçlarını getir
                                return viewModel.searchResults
                            }
                        }()
                        
                        // Başlık ve Temizle Butonu
                        HStack {
                            if let category = selectedCategory {
                                Text(category.name.capitalized)
                            } else {
                                Text("Search Results")
                            }
                            
                            Spacer()
                            
                            // Filtreyi Temizle Butonu
                            if selectedCategory != nil {
                                Button("Clear Filter") {
                                    selectedCategory = nil
                                    isFocused = false
                                }
                                .font(.caption)
                                .foregroundStyle(.red)
                            }
                        }
                        .font(.headline)
                        .foregroundStyle(Color("SecondColor"))
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Yükleniyor veya Boş Durumu
                        if searchText.isEmpty && selectedCategory == nil {
                            // Bu duruma düşmez ama güvenlik için
                            EmptyView()
                        } else if viewModel.isSearching && selectedCategory == nil {
                            ProgressView("Searching...")
                                .padding(.top, 50)
                        } else if productsToShow.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "magnifyingglass.circle")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.gray.opacity(0.3))
                                Text("No results found.")
                                    .foregroundStyle(.gray)
                            }
                            .padding(.top, 50)
                        } else {
                            // Ürün Listesi
                            LazyVGrid(columns: productColumns, spacing: 16) {
                                ForEach(productsToShow) { product in
                                    let isFavorite = favoriteItems.contains(where: { $0.productId == product.id })
                                    
                                    NavigationLink {
                                        ProductDetailView(product: product)
                                    } label: {
                                        ProductCardView(
                                            product: product,
                                            isFavorite: isFavorite,
                                            onFavoriteToggle: {
                                                toggleFavorite(product: product)
                                            }
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGray6))
        .navigationBarHidden(true)
        
    }
    
    // Favori Fonksiyonu
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
