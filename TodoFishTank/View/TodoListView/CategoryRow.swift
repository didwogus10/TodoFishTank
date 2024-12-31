//
//  CategoryRow.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/13/24.
//

import SwiftUI

struct CategoryRow: View {
    @EnvironmentObject var todoViewModel: TodoViewModel

    var body: some View {
        HStack (spacing : 0) {
            if todoViewModel.categories.isEmpty {
                Text("카테고리를 추가해보세요 >")
                Spacer()
            }
            
            else{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(todoViewModel.categories) { category in
                            CategoryBadge(
                                category: category,
                                isSelected: todoViewModel.selectedCategory == category.id
                            )
                            .onTapGesture {
                                todoViewModel.selectedCategory = category.id                            }
                            .padding(.trailing, 5)
                        }
                    }
                    .padding(.vertical, 7)
                }
            }
            
            Divider()
                .padding(.trailing, 13)
            
            AddCategoryButton()
            
        }
        .frame(height: 70)
    }
}

#Preview {
    CategoryRow()
        .environmentObject(TodoViewModel(todoService: TodoService()))
}
