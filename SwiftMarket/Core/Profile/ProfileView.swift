//
//  ProfileView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import SwiftUI
import Kingfisher // 1. Kütüphaneyi ekledik

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    // Çıkış yapınca Login ekranına atmak için AppStorage'ı dinliyoruz
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // --- 1. PROFIL BAŞLIĞI ---
                    VStack(spacing: 12) {
                        // Profil Resmi (KINGFISHER GÜNCELLEMESİ)
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
                        
                        // İsim ve Email
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
                    
                    // --- 2. MENÜ LİSTESİ ---
                    VStack(spacing: 16) {
                        
                        // Grup 1: Hesap
                        SettingsGroup {
                            SettingsRow(icon: "bag.fill", title: "My Orders")
                            Divider()
                            SettingsRow(icon: "map.fill", title: "My Addresses")
                            Divider()
                            SettingsRow(icon: "creditcard.fill", title: "Payment Methods")
                        }
                        
                        // Grup 2: Uygulama
                        SettingsGroup {
                            SettingsRow(icon: "gearshape.fill", title: "Settings")
                            Divider()
                            SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support")
                        }
                        
                        // Çıkış Butonu
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

// --- YARDIMCI GÖRÜNÜMLER ---

// Menü Grubu (Beyaz kutu)
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

// Menü Satırı
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
        // Tıklanabilir gibi hissettirmek için arka plan
        .contentShape(Rectangle())
    }
}

#Preview {
    ProfileView()
}
