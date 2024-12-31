//
//  Profile.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/15/24.
//

import SwiftUI

struct Profile: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isDarkMode = false
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Image("growthLevel/\(userViewModel.fishLevel)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    /*.clipShape(Circle())  */  // 크기가 커져도 비율 유지
                    .frame(width: 50)
                
                VStack (alignment: .leading){
                    Text(userViewModel.user?.name ?? "회원님")
                        .font(.system(size: 19, weight: .bold))
                    Text("물고기 레벨 : \(userViewModel.fishLevel)단계") // 언제 가입했다? // 몇일째 진행중이에요
                        .font(.system(size: 13))
                }
                .padding(.leading, 7)
                Spacer()
                Badge(circleColor: .yellow, text: "\(userViewModel.user?.point ?? 0)")
            }
            
            //            HStack {
            //                Toggle(isOn: $isDarkMode) {
            //                    Text("다크모드")
            //                }
            //            }
            
//            Button(action: {} ) {Label("리뷰 남기기", systemImage: "ellipsis.message")
//            }.buttonStyle(.plain)
        }
    }
}

#Preview {
    Profile()
        .environmentObject(UserViewModel(userService: UserService()))
}
