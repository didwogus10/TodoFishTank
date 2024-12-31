//
//  ProgressImage.swift
//  TodoFishTank
//
//  Created by 양재현 on 10/7/24.
//

import SwiftUI

struct ProgressImage: View {
    @EnvironmentObject var todoViewModel: TodoViewModel

    var body: some View {
        //달성률별로 5단계로 나누기
        let imageIndex = min((todoViewModel.completionRate / 20) + 1, 5)
        
        Image("progress/\(imageIndex)")
                .resizable()
                .frame(width: 206, height: 206)
    }
}

#Preview {
    ProgressImage().environmentObject(TodoViewModel(todoService: TodoService()))
}
