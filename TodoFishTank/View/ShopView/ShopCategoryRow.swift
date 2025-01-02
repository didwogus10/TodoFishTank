//
//  ShopCategoryRow.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/19/24.
//

import SwiftUI

struct ShopCategoryRow: View {
    @EnvironmentObject var shopViewModel: ShopViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(shopCategories) { category in
                    ShopCategoryBadge( category : category,
                                       isSelected: shopViewModel.selectedCategory == category.id
                    )
                    .onTapGesture {
                        shopViewModel.selectedCategory = category.id
                    }
                }
                .padding(.trailing, 7)
            }
            .padding(.vertical, 1)
        }
        .scrollClipDisabled()
    }
}

#Preview {
    ShopCategoryRow()
        .environmentObject(ShopViewModel(shopService: ShopService()))
}
