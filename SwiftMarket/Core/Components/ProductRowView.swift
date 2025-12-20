//
//  ProductRowView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 12.12.2025.
//


import SwiftUI
import SwiftData
import Kingfisher

struct ProductRowView: View {
    let title: String
    let products: [Product]
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteItems: [FavoriteItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("SecondColor"))
                
                Spacer()
                
                NavigationLink {
                    CategoryDetailView(title: title, products: products)
                } label: {
                    Text("See All")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("BrandColor"))
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(products) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            ProductCardView(product: product)
                            .frame(width: UIScreen.main.bounds.width * 0.4)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
    }
}
