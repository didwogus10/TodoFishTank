//
//  TodoItem.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/13/24.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject var todoViewModel: TodoViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var todo: Todo
    
    var body: some View {
        HStack(spacing: 26) {
            Button(action: {
                Task{
                    // task에 대해 더 알아보기
                    try await todoViewModel.modifyTodoDone(todo: todo)
                    if todoViewModel.completionRate == 100 {
                       try await userViewModel.getPoint()
                    }
                }
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 22, height: 22)
                        .background(
                            todo.isComplete ? LinearGradient.taskCheck : LinearGradient.solidColor(Color.gray))
                        .cornerRadius(5)
                    
                    //나중에 삼항연산자로 바꾸기
                    if todo.isComplete {
                        Image("check")
                            .resizable()
                            .frame(width: 18, height: 13)
                            .offset(x: 5, y: -3)
                    }
                }
                
            }.disabled(!DateHelper.isToday(todoViewModel.selectedDay))//다른날들 버튼 비활성화

            if todoViewModel.isEditMode {
                NavigationLink(destination: EditTodoView(todo: $todo)){
                    Text(todo.title)
                        .font(.system(size: 17))
                        .underline()
                    
                }
                .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
            } else {
                Text(todo.title)
                    .font(.system(size: 17))
            }

            
            
            Spacer()
//            if todoViewModel.isEditMode {
//                Image(systemName: "line.3.horizontal")
//                    .resizable()
//                    .frame(width: 18, height: 13)
//                    .foregroundColor(.gray)
//                
//            }
            //--> 이거는 투두리스트 위치바꾸는거 나중에적용
        }
        
        
    }
}

#Preview {
    @Previewable @State var sampleTodoItem = Todo(title: "string", isComplete: false)
    NavigationStack{
        TodoView(todo: $sampleTodoItem)
            .environmentObject(TodoViewModel(todoService: TodoService()))
            .environmentObject(UserViewModel(userService: UserService()))
                               }
}
