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
    @State private var selectedCategory: Category?
    @State private var searchTask: Task<Void, Never>?
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteItems: [FavoriteItem]
    
    private let categoryColumns = [
        GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 10)
    ]
    
    private let productColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
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
                            if !newValue.isEmpty { selectedCategory = nil }
                            
                            searchTask?.cancel()
                            searchTask = Task {
                                try? await Task.sleep(nanoseconds: 500_000_000)
                                if !Task.isCancelled && !newValue.isEmpty {
                                    await viewModel.performSearch(query: newValue)
                                }
                            }
                        }
                    
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
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    if searchText.isEmpty && selectedCategory == nil {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Categories")
                                .font(.headline)
                                .foregroundStyle(.gray)
                            
                            LazyVGrid(columns: categoryColumns, spacing: 12) {
                                ForEach(viewModel.categories) { category in
                                    Button {
                                        selectedCategory = category
                                        isFocused = false
                                        searchText = ""
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
                        let productsToShow: [Product] = {
                            if let category = selectedCategory {
                                return viewModel.productsByCategory[category.slug] ?? []
                            } else {
                                return viewModel.searchResults
                            }
                        }()
                        
                        HStack {
                            if let category = selectedCategory {
                                Text(category.name.capitalized)
                            } else {
                                Text("Search Results")
                            }
                            
                            Spacer()
                            
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
                        
                        if searchText.isEmpty && selectedCategory == nil {
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
                            LazyVGrid(columns: productColumns, spacing: 16) {
                                ForEach(productsToShow) { product in
                                    NavigationLink {
                                        ProductDetailView(product: product)
                                    } label: {
                                        ProductCardView(product: product)
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
}
