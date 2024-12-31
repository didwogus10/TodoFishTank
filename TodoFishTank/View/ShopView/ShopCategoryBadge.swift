//
//  ShopCategoryBadge.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/19/24.
//

import SwiftUI

struct ShopCategoryBadge: View {
    var category : ShopCategory
    var isSelected: Bool
    var body: some View {
        Text(category.name)
            .font(.system(size: 14))
            .padding(.horizontal, 13)
            .padding(.vertical, 6)
            .background(isSelected ? Color(hex: "#393939") : .white.opacity(0.35))
            .foregroundColor(isSelected ? .white : .black)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white, lineWidth: 1)
            )
    }
}

#Preview {
    let sampleCategory = ShopCategory(id: 0, name: "꾸미기", shopItems: [])
    ShopCategoryBadge(category: sampleCategory, isSelected: true)
}
