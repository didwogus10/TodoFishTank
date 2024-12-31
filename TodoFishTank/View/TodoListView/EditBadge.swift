//
//  EditButton.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/13/24.
//

import SwiftUI

struct EditBadge: View {
    @EnvironmentObject var todoViewModel: TodoViewModel
    var body: some View {
        Button(action: {
            todoViewModel.isEditMode.toggle()
        }) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 38, height: 23)
                    .background(
                        todoViewModel.isEditMode ?
                            .gray.opacity(0.58) :
                        .white.opacity(0.58))
                
                    .cornerRadius(34)
                    .overlay(
                        RoundedRectangle(cornerRadius: 34)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 1)
                        
                    )
                Text("편집")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
            }
        }
    }
}

#Preview {
    EditBadge()
        .environmentObject(TodoViewModel(todoService: TodoService()))
}
