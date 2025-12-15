//
//  CartView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import SwiftUI
import SwiftData
import Kingfisher

struct CartView: View {
    
    @StateObject private var viewModel = CartViewModel()
    @Query(sort: \CartItem.title) private var cartItems: [CartItem]
    @Environment(\.modelContext) private var modelContext
    
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                
                if cartItems.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart.badge.minus")
                            .font(.system(size: 80))
                            .foregroundStyle(.gray.opacity(0.5))
                        Text("Your cart is empty")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondColor"))
                    }
                    .frame(maxHeight: .infinity)
                    
                } else {
                    List {
                        ForEach(cartItems) { item in
                            HStack(spacing: 12) {
                                KFImage(URL(string: item.image))
                                    .placeholder { Color.gray.opacity(0.1) }
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(item.title)
                                        .font(.headline)
                                        .foregroundStyle(Color("SecondColor"))
                                        .lineLimit(1)
                                    
                                    HStack(spacing: 0) {
                                        Button { viewModel.decrementQuantity(item) } label: {
                                            Image(systemName: "minus")
                                                .frame(width: 28, height: 28)
                                                .background(Color(.systemGray6))
                                                .foregroundColor(.gray)
                                        }
                                        .buttonStyle(.plain)
                                        
                                        Text("\(item.quantity)")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .frame(width: 32, height: 28)
                                            .background(Color(.systemGray6))
                                            .foregroundStyle(Color("SecondColor"))
                                        
                                        Button { viewModel.incrementQuantity(item) } label: {
                                            Image(systemName: "plus")
                                                .frame(width: 28, height: 28)
                                                .background(Color(.systemGray6))
                                                .foregroundColor(Color("SecondColor"))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .cornerRadius(6)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("$\(item.totalValue, specifier: "%.2f")")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("BrandColor"))
                                    Text("$\(item.price, specifier: "%.2f") / each")
                                        .font(.caption2)
                                        .foregroundStyle(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteItem(item, context: modelContext)
                                } label: { Label("Delete", systemImage: "trash") }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .padding(.bottom, 80)
                }
                
                if !cartItems.isEmpty {
                    VStack(spacing: 0) {
                        Divider()
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total Amount")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text("$\(viewModel.calculateTotal(items: cartItems), specifier: "%.2f")")
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(Color("SecondColor"))
                            }
                            Spacer()
                            Button {
                                showSuccessAlert = true
                            } label: {
                                Text("Checkout")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .background(Color("BrandColor"))
                                    .cornerRadius(16)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: -5)
                    }
                }
                
            }
            .alert("Order Received!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    withAnimation {
                        viewModel.clearCart(items: cartItems, context: modelContext)
                    }
                }
            } message: {
                Text("Thank you for your purchase. Your items will be shipped soon.")
            }
            .navigationTitle("My Cart")
        }
    }
}

#Preview {
    CartView()
        .modelContainer(for: CartItem.self)
}
