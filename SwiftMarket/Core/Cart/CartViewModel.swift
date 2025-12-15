//
//  CartViewModel.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 12.12.2025.
//

import Foundation
import SwiftData

class CartViewModel: ObservableObject {
    
    // Toplam tutarı hesapla
    func calculateTotal(items: [CartItem]) -> Double {
        return items.reduce(0) { $0 + $1.totalValue }
    }
    
    // Ürünü tamamen sil
    func deleteItem(_ item: CartItem, context: ModelContext) {
        context.delete(item)
    }
    
    // Adet artır
    func incrementQuantity(_ item: CartItem) {
        item.quantity += 1
    }
    
    // Adet azalt
    func decrementQuantity(_ item: CartItem) {
        if item.quantity > 1 {
            item.quantity -= 1
        }
    }
    
    func clearCart(items: [CartItem], context: ModelContext) {
        for item in items {
            context.delete(item)
        }
    }
}
