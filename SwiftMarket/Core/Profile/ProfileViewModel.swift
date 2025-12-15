//
//  ProfileViewModel.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 12.12.2025.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var user: User?
    
    init() {
        loadUser()
    }
    
    // Hafızadaki kullanıcıyı geri getir
    func loadUser() {
        if let savedData = UserDefaults.standard.data(forKey: "savedUser") {
            if let decodedUser = try? JSONDecoder().decode(User.self, from: savedData) {
                self.user = decodedUser
            }
        }
    }
    
    // Çıkış Yap
    func logout() {
        // 1. Hafızayı temizle
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "savedUser")
        
        // 2. Veriyi sıfırla
        self.user = nil
    }
}
