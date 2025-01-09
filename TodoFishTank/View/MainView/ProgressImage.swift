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
        let imageIndex: Int
        switch todoViewModel.completionRate {
               case 0...14:
                   imageIndex = 1
               case 15...39:
                   imageIndex = 2
               case 40...60:
                   imageIndex = 3
               case 61...85:
                   imageIndex = 4
               case 86...100:
                   imageIndex = 5
               default:
                   imageIndex = 1 // 기본값 (0 미만이거나 100 초과일 경우)
               }
        
        return LottieView(animationFileName: "water\(imageIndex)", loopMode: .loop)
            .frame(width: 206, height: 206)
            .id(imageIndex) // 뷰가 달라질 때마다 새로운 ID 할당
    }
}

#Preview {
    ProgressImage().environmentObject(TodoViewModel(todoService: TodoService()))
}
