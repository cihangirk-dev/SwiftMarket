//
//  ProfileView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    VStack(spacing: 12) {
                        KFImage(URL(string: viewModel.user?.image ?? ""))
                            .placeholder {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundStyle(.gray.opacity(0.3))
                            }
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 5)
                        
                        VStack(spacing: 4) {
                            Text("\(viewModel.user?.firstName ?? "Guest") \(viewModel.user?.lastName ?? "User")")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Color("SecondColor"))
                            
                            Text(viewModel.user?.email ?? "Sign in to see details")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        
                        SettingsGroup {
                            SettingsRow(icon: "bag.fill", title: "My Orders")
                            Divider()
                            SettingsRow(icon: "map.fill", title: "My Addresses")
                            Divider()
                            SettingsRow(icon: "creditcard.fill", title: "Payment Methods")
                        }
                        
                        SettingsGroup {
                            SettingsRow(icon: "gearshape.fill", title: "Settings")
                            Divider()
                            SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support")
                        }
                        
                        Button {
                            viewModel.logout()
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Log Out")
                                Spacer()
                            }
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .background(Color(.systemGray6))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsGroup<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(Color("BrandColor"))
                .frame(width: 30)
            
            Text(title)
                .font(.body)
                .foregroundStyle(Color("SecondColor"))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.gray.opacity(0.5))
        }
        .padding()
        .contentShape(Rectangle())
    }
}

#Preview {
    ProfileView()
}
