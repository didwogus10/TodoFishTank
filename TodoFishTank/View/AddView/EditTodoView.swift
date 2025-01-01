//
//  EditTodoView.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/25/24.
//

import SwiftUI

struct EditTodoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var todoViewModel: TodoViewModel
    
    @Binding var todo: Todo
    @State private var isShowAlert : Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section("할 일 이름") {
                    TextField("텍스트를 입력하세요...", text : $todo.title)
                }
                
                Text("할 일 삭제하기")
                    .font(Font.custom("Pretendard", size: 17))
                    .underline()
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 1, green: 0.38, blue: 0.34))
                    .onTapGesture {
                        isShowAlert = true
                    }.alert("삭제하기", isPresented: $isShowAlert) {
                        Button("취소") { }
                        Button("확인") {
                            Task{
                                try await todoViewModel.deleteTodo(todo: todo)}
                            dismiss()
                        }
                    } message: {
                        Text("정말 삭제하시겠습니까?")
                    }
            }
            
            
            Button(action: {
                Task{
                    try await todoViewModel.updateTodo(todo: todo)}
                dismiss()
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 70)
                        .background(
                            LinearGradient.categoryBadge
                        )
                    
                    Text("편집하기")
                        .font(
                            Font.system(size: 19)
                                .weight(.bold)
                        )
                        .foregroundColor(.white)
                }
            }
            .disabled(todo.title.isEmpty) // 입력이 없으면 비활성화
            .opacity(todo.title.isEmpty ? 0.5 : 1)
            
            .navigationTitle("할 일 편집하기") //타이틀
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.black)
                    })
                }}
        } // 비활성화 상태에 따라 투명도 조정
        
    }
}





#Preview {
    @Previewable @State var sampleTodoItem = Todo(title: "string", isComplete: false)
    EditTodoView(todo: $sampleTodoItem)
        .environmentObject(TodoViewModel(todoService: TodoService()))
}

