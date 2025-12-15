//
//  CategoryRowView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 12.12.2025.
//

import SwiftUI

struct CategoryRowView: View {
    let categories: [Category]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Categories")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color("SecondColor"))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories) { category in
                        Button {
                            print("Kategori seçildi: \(category.name)")
                        } label: {
                            Text(category.name.replacingOccurrences(of: "-", with: " ").capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color("SecondColor"))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                .overlay(
                                    Capsule()
                                        .stroke(Color(.systemGray5), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
    }
}
