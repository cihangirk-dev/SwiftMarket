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
                HStack(spacing: 10) { // Butonlar arası boşluk
                    ForEach(categories) { category in
                        Button {
                            print("Kategori seçildi: \(category.name)")
                        } label: {
                            // Metni Düzenleme: Tireleri boşluk yap ve Baş Harfleri Büyüt
                            Text(category.name.replacingOccurrences(of: "-", with: " ").capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color("SecondColor")) // Yazı rengi koyu
                                .padding(.horizontal, 20) // Yanlardan genişlik
                                .padding(.vertical, 12)   // Dikey yükseklik
                                .background(Color.white)  // Arkaplan BEYAZ
                                .clipShape(Capsule())     // HAP ŞEKLİ (Uzun isme göre uzar)
                                // Hafif gölge ve ince çerçeve ile belirginleştirme
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                .overlay(
                                    Capsule()
                                        .stroke(Color(.systemGray5), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10) // Alt gölgenin kesilmemesi için boşluk
            }
        }
    }
}
