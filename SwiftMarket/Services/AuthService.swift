//
//  AuthService.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 9.12.2025.
//

import Foundation

class AuthService {
    
    static let shared = AuthService()
    private init() {}
    
    func login(username: String, password: String) async throws -> User {
        
        guard let url = URL(string: "https://dummyjson.com/auth/login") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["username": username, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let user = try JSONDecoder().decode(User.self, from: data)
        return user
    }
}
