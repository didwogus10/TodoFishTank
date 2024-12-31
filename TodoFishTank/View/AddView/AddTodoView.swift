//
//  TodoName.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/14/24.
//

import SwiftUI

struct AddTodoView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var todoViewModel: TodoViewModel
    @State private var title = ""
//    @State private var isHighlight = false
    @State private var selectedTime = Date()
    
    
    var body: some View {
        VStack {
            Form {
                Section("할 일 이름") {
                    TextField("텍스트를 입력하세요...", text : $title)
                    
                }
//                Section("할 일 설정") {
//                    DatePicker("언제까지 할래요?", selection: $selectedTime,
//                               displayedComponents: .hourAndMinute)
//                    Toggle(isOn: $isHighlight) {
//                        Text("형광펜")
//                    }}
                
            }
            Button(action: {
                todoViewModel.addTodo(todo: Todo(title: title, isComplete: false, userId: userViewModel.user?.id, categoryId: todoViewModel.selectedCategory))
                
                
                dismiss()
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 94)
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
            .disabled(title.isEmpty) // 입력이 없으면 비활성화
            .opacity(title.isEmpty ? 0.5 : 1) // 비활성화 상태에 따라 투명도 조정
            
            
        }
        
        .navigationTitle("할 일 추가하기") //타이틀
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
    AddTodoView()
        .environmentObject(UserViewModel(userService: UserService()))
        .environmentObject(TodoViewModel(todoService: TodoService()))
}
