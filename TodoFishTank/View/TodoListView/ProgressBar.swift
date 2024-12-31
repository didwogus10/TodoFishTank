//
//  ProgressBar.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/13/24.
//

import SwiftUI

struct ProgressBar: View {
    @EnvironmentObject var todoViewModel: TodoViewModel
    
    var body: some View {
        if todoViewModel.selectedCategory != nil{
            let todoList =
            todoViewModel.todoList.filter {$0.categoryId == todoViewModel.selectedCategory && DateHelper.isSelectedDay($0.createdAt, selectedDay: todoViewModel.selectedDay)} //투두리스트중에 categoryId 가 selectedCategory인것 뽑기 && 선택된날의 투두리스트
            
            GeometryReader { geometry in
                // 현재 카테고리의 할 일 총 개수와 완료된 할 일 개수 계산
                let totalTasks = todoList.count
                let completedTasks = todoList.filter { $0.isComplete }.count
                
                // 남은 할 일의 비율 역으로 계산
                let progress = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0.0
                let reverseProgress = 1.0 - progress
                let progressBarWidth = geometry.size.width
                let fishPositionX = progress * progressBarWidth
                
                ZStack(alignment: .topLeading) {
                    ProgressView(value: reverseProgress)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        .tint(Color(red: 0.95, green: 0.63, blue: 0.52, opacity: 1.0))
                        .scaleEffect(x: -1, y: 1)// X축 반전
                    
                    Image("progress_fish")
                        .resizable()
                        .frame(width: 35, height: 18)
                        .position(x: fishPositionX)
                }
                
                HStack {
                    Spacer()
                    Text("\(completedTasks) / \(totalTasks)")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(
                            Color(red: 0.95, green: 0.63, blue: 0.52, opacity: 1.0))
                }
                .padding(.top , 10)
            }
            .frame(height: 40)
        } }
}

#Preview {
    ProgressBar()
        .environmentObject(TodoViewModel(todoService: TodoService()))
}
