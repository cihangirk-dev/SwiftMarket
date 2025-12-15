//
//  HomeView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import SwiftUI
import SwiftData
import Kingfisher

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteItems: [FavoriteItem]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    HeaderView()
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 12)
                }
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                .zIndex(1)
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        
                        if viewModel.isLoading && viewModel.categories.isEmpty {
                            ProgressView("Loading Market...")
                                .padding(.top, 50)
                        } else {
                            
                            if !viewModel.sliderProducts.isEmpty {
                                DiscountSliderView(products: viewModel.sliderProducts)
                                    .padding(.top, 10)
                            }
                            
                            ForEach(viewModel.categories) { category in
                                if let products = viewModel.productsByCategory[category.slug], !products.isEmpty {
                                    
                                    let cleanTitle = category.name.replacingOccurrences(of: "-", with: " ").capitalized
                                    ProductRowView(title: cleanTitle, products: products)
                                }
                            }
                            
                            if viewModel.productsByCategory.count < viewModel.categories.count {
                                ProgressView()
                                    .padding()
                            }
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            .background(Color(.systemGray6))
            .task {
                if viewModel.categories.isEmpty {
                    await viewModel.fetchAllData()
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 16) {
            
            HStack(spacing: 8) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                
                Text("SwiftMarket")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color("SecondColor"))
            }
            
            Spacer()
            
            NavigationLink {
                SearchView(viewModel: viewModel)
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("SecondColor"))
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
            
            NavigationLink {
                ProfileView()
            } label: {
                Image(systemName: "person.fill")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("SecondColor"))
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
        }
    }
    
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

struct DiscountSliderView: View {
    let products: [Product]
    
    @State private var currentPage = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Deals")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color("SecondColor"))
                .padding(.horizontal)
            
            TabView(selection: $currentPage) {
                ForEach(Array(products.enumerated()), id: \.element.id) { index, product in
                    NavigationLink {
                        ProductDetailView(product: product)
                    } label: {
                        ZStack(alignment: .bottomLeading) {
                            Color.white
                            
                            KFImage(URL(string: product.thumbnail))
                                .placeholder{
                                    Color.gray.opacity(0.2)
                            }
                                .resizable()
                                .scaledToFit()
                                .frame(height: UIScreen.main.bounds.height * 0.25)
                                .frame(maxWidth: .infinity)
                            
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.6)],
                                startPoint: .center,
                                endPoint: .bottom
                            )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("-\(Int(product.discountPercentage))%")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.red)
                                    .clipShape(Capsule())
                                
                                Text(product.title)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                            }
                            .padding()
                        }
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.25)
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .onReceive(timer) { _ in
                withAnimation {
                    if currentPage < products.count - 1 {
                        currentPage += 1
                    } else {
                        currentPage = 0
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
