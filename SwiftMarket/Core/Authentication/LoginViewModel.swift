//
//  LoginViewModel.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username = "" // Test için: emilys
    @Published var password = "" // Test için: emilyspass
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await AuthService.shared.login(username: username, password: password)
            self.currentUser = user
            
            // 1. Giriş yapıldı bayrağını kaldır
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            // 2. YENİ: Kullanıcı verisini JSON'a çevirip kaydet (Profil sayfası için)
            if let encodedData = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encodedData, forKey: "savedUser")
            }
            
            print("Login Success: \(user.firstName) \(user.lastName)")
        } catch {
            self.errorMessage = "Login failed. Please check your credentials."
            print("Error: \(error.localizedDescription)")
        }
        isLoading = false
    }
}
