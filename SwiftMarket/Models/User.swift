//
//  User.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 9.12.2025.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let image: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case id, username, email, gender, image, lastName, firstName
        case token = "accessToken"
    }
}
