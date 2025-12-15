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
    
    func loadUser() {
        if let savedData = UserDefaults.standard.data(forKey: "savedUser") {
            if let decodedUser = try? JSONDecoder().decode(User.self, from: savedData) {
                self.user = decodedUser
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "savedUser")
        
        self.user = nil
    }
}
