//
//  TodoList.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/13/24.
//

import SwiftUI

struct TodoList: View {
    @EnvironmentObject var todoViewModel: TodoViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading, spacing: 33) {
                //선택된 카테고리가 있을때만
                if todoViewModel.selectedCategory != nil{
                    let todoList =
                    todoViewModel.todoList.filter {$0.categoryId == todoViewModel.selectedCategory && DateHelper.isSelectedDay($0.createdAt, selectedDay: todoViewModel.selectedDay)} //투두리스트중에 categoryId 가 selectedCategory인것 뽑기 +  오늘의 투두리스트만 필터링
                    ForEach(todoList) { todo in
                        TodoView(todo: $todoViewModel.todoList.first { $0.id == todo.id }!) //이 부분 오류난다면 ..?
                    }
                    if DateHelper.isToday(todoViewModel.selectedDay){
                        AddTodoButton()
                    }
                    
                }
            }
        }
        
    }}


#Preview {
    TodoList()
        .environmentObject(TodoViewModel(todoService: TodoService()))
}
