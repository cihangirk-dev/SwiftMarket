//
//  LoginViewModel.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await AuthService.shared.login(username: username, password: password)
            self.currentUser = user
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            if let encodedData = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encodedData, forKey: "savedUser")
            }
        } catch {
            self.errorMessage = "Login failed. Please check your credentials."
        }
        isLoading = false
    }
}
