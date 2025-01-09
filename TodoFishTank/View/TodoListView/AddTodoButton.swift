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
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient.categoryBadge)
                        .frame(width: 22, height: 22)
                    
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 10, height: 10)
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
