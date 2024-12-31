//
//  AddTask.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/13/24.
//

import SwiftUI

struct AddTodoButton: View {
    
    var body: some View {
        HStack(spacing: 26) {
            NavigationLink(destination: AddTodoView())  {
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 22, height: 22)
                        .background(
                            LinearGradient.categoryBadge)
                        .cornerRadius(5)
                    
                    Text("+") // Rectangle 내부에 텍스트 추가
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                }
                
                
                
            }
            
            Text("할 일 추가하기")
                .font(.system(size: 17))
        }
        
    }
}

#Preview {
    NavigationStack{
        AddTodoButton()
    }
}
