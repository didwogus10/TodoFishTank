//
//  AddCategoryView.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/14/24.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var todoViewModel: TodoViewModel
    @State private var categoryName = ""
    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section("카테고리 이름") {
                    
                    TextField("텍스트를 입력하세요...", text : $categoryName)
                    
                }
                
            }
            Button(action: {
//                userViewModel.addCategory(name: categoryName)
                todoViewModel.addCategory(category: TodoCategory(name: categoryName, userId: userViewModel.user?.id ))
                dismiss()
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 70)
                        .background(
                            LinearGradient.categoryBadge
                        )
                    
                    Text("추가하기")
                        .font(
                            Font.system(size: 19)
                                .weight(.bold)
                        )
                        .foregroundColor(.white)
                }
            }
            .disabled(categoryName.isEmpty) // 입력이 없으면 비활성화
            .opacity(categoryName.isEmpty ? 0.5 : 1) // 비활성화 상태에 따라 투명도 조정
            
            
        } .navigationTitle("카테고리 추가하기") //타이틀
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline) //스타일
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.black)
                    })
                }}}
        
        
        
    }


#Preview {
    AddCategoryView()
//        .environmentObject(UserViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(TodoViewModel(todoService: TodoService()))
}
