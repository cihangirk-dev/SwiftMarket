//
//  ProductDetailView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import SwiftUI
import SwiftData
import Kingfisher

struct ProductDetailView: View {
    
    let product: Product
    @State private var quantity = 1
    @State private var showAddedAlert = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var cartItems: [CartItem]
    @Query private var favoriteItems: [FavoriteItem]
    
    var isFavorite: Bool {
        return FavoriteManager.shared.isFavorite(productId: product.id, items: favoriteItems)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    ZStack(alignment: .topTrailing) {
                        if !product.images.isEmpty {
                            TabView {
                                ForEach(product.images, id: \.self) { imageUrl in
                                    KFImage(URL(string: imageUrl))
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            .tabViewStyle(.page)
                            .frame(height: 300)
                            .indexViewStyle(.page(backgroundDisplayMode: .always))
                            
                        } else {
                            KFImage(URL(string: product.thumbnail))
                                .placeholder {
                                    Color.gray.opacity(0.1)

                                }
                                .cacheOriginalImage()
                                .downsampling(size: CGSize(width: 200, height: 200))
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .frame(height: UIScreen.main.bounds.height * 0.4)
                                .background(Color.white)
                        }
                        
                        if product.discountPercentage > 0 {
                            Text("\(Int(product.discountPercentage))% OFF")
                                .font(.caption).fontWeight(.bold).foregroundStyle(.white)
                                .padding(8).background(Color.red).clipShape(Capsule()).padding()
                        }
                    }
                    .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        HStack(alignment: .top) {
                            Text(product.title)
                                .font(.title).fontWeight(.bold).foregroundStyle(Color("SecondColor"))
                                .lineLimit(2)
                            Spacer()
                            Button {
                                FavoriteManager.shared.toggleFavorite(product: product, context: modelContext, items: favoriteItems)
                            } label: {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .font(.title2).foregroundStyle(isFavorite ? .red : .gray)
                                    .padding(10).background(Color(.systemGray6)).clipShape(Circle())
                            }
                        }
                        
                        HStack {
                            Text(product.brand ?? "General")
                                .font(.subheadline).fontWeight(.medium).foregroundStyle(.gray)
                            Spacer()
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill").foregroundStyle(.yellow).font(.caption)
                                Text(product.ratingString).fontWeight(.bold).foregroundStyle(.gray)
                            }
                        }
                        
                        Divider().padding(.vertical, 8)
                        
                        Text("Description").font(.headline).foregroundStyle(Color("SecondColor"))
                        Text(product.description).font(.body).foregroundStyle(.gray).lineSpacing(5)
                        
                        Divider().padding(.vertical, 20)
                        
                        HStack {
                            Text("Quantity")
                                .font(.headline)
                                .foregroundStyle(Color("SecondColor"))
                            
                            Spacer()
                            
                            HStack(spacing: 0) {
                                Button {
                                    if quantity > 1 { quantity -= 1 }
                                } label: {
                                    Image(systemName: "minus")
                                        .frame(width: 35, height: 35)
                                        .background(Color(.systemGray6))
                                        .foregroundColor(.gray)
                                }
                                
                                Text("\(quantity)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .frame(width: 40, height: 35)
                                    .background(Color(.systemGray6))
                                    .foregroundStyle(Color("SecondColor"))
                                
                                Button {
                                    quantity += 1
                                } label: {
                                    Image(systemName: "plus")
                                        .frame(width: 35, height: 35)
                                        .background(Color(.systemGray6))
                                        .foregroundColor(Color("SecondColor"))
                                }
                            }
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer().frame(height: 120)
                }
            }
            
            VStack(spacing: 0) {
                Divider()
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Price")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text("$\(product.discountPrice * Double(quantity), specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color("BrandColor"))
                    }
                    Spacer()
                    Button {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        addToCart()
                    } label: {
                        Text("Add to Cart")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(Color("BrandColor"))
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 10)
            }
            .background(Color.white)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
        }
        .navigationBarBackButtonHidden(true)
        .alert("Success", isPresented: $showAddedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Product added to your cart!")
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline).foregroundColor(Color("SecondColor"))
                        .padding(8).background(Color.white.opacity(0.8)).clipShape(Circle())
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func addToCart() {
        if let existingItem = cartItems.first(where: { $0.productId == product.id }) {
            existingItem.quantity += quantity
        } else {
            let newItem = CartItem(
                productId: product.id,
                title: product.title,
                price: product.discountPrice,
                quantity: quantity,
                image: product.thumbnail,
                brand: product.brand
            )
            modelContext.insert(newItem)
        }
        showAddedAlert = true
    }
}
