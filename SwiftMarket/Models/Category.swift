//
//  Category.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 12.12.2025.
//

import Foundation

struct Category: Codable, Identifiable, Hashable {
    let slug: String
    let name: String
    
    var id: String { slug }
}
