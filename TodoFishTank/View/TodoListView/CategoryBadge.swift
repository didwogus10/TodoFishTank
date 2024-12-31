//
//  CategoryBadge.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/13/24.
//

import SwiftUI


struct CategoryBadge: View {
    @EnvironmentObject var todoViewModel: TodoViewModel
    @State private var isShowAlert: Bool = false
    
    var category : TodoCategory
    var isSelected: Bool
    
    var body: some View {
        
        ZStack(alignment:.topTrailing) {
            Text(category.name)
                .padding(.horizontal, 19)
                .padding(.vertical, 10)
                .background(isSelected ? LinearGradient.categoryBadge : LinearGradient.solidColor(Color.white))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.clear : Color.gray, lineWidth: 1)
                )
            if todoViewModel.isEditMode{
                
                DeleteCategoryButton()
                    .offset(x: 5, y: -5)
                    .onTapGesture {
                    isShowAlert = true
                    
                }.alert("삭제하기", isPresented: $isShowAlert) {
                    
                    Button("취소") { }
                    Button("확인") {
                        Task{try await todoViewModel.deleteCategory(category: category)}
                    }
                    
                    
                } message: {
                    Text("정말 삭제하시겠습니까?\n카테고리안에 모든할일이 삭제됩니다.")
                
            }
            }
            
        }.padding(0)
    }
}

#Preview {
    CategoryBadge( category : TodoCategory(name: "String"), isSelected: true )
        .environmentObject(TodoViewModel(todoService: TodoService()))
}
