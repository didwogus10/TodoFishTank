//
//  PercentView.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/12/24.
//

import SwiftUI

struct PercentCard: View {
    @EnvironmentObject var todoViewModel: TodoViewModel
    
    var body: some View {
        VStack {
            Text("전체 달성률")
                .font(.system(size: 20))
                .fontWeight(.medium)
                .padding(.bottom, 1)
            Text("모두 채워서 먹이와 포인트를 받으세요!")
                .font(.system(size: 15))
                .fontWeight(.regular)
                .foregroundColor(Color(hex: "#595959"))
            ProgressImage()
                
            Text("\(todoViewModel.completionRate)%")
                .font(.system(size: 32))
                .foregroundColor(Color(hex: "#7372F4"))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/) //task처리 !!!!
            
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
              .fill(.white.opacity(0.75))
                .shadow(color: Color(hex: "#000000").opacity(0.25), radius: 12.1, x: 0, y: 4)
                
            
        )
    }
    
}

#Preview {
    PercentCard()
        .environmentObject(TodoViewModel(todoService: TodoService()))
}
