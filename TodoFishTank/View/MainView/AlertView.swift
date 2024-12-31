//
//  Alert.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/16/24.
//

import SwiftUI

struct AlertView: View {
    @Binding var isAlertShow: Bool
    var image: String
    var title: String
    var message: String
    var body: some View {
        if isAlertShow{
            ZStack {
                Color.black.opacity(0.4) // 어두운 배경
                    .edgesIgnoringSafeArea(.all)
                
                VStack() {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 155, height: 147)
                    
                    Spacer()
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .padding(.bottom, 4)
                    
                    Text(message)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.bottom, 28)
                    Button(action: {
                        isAlertShow.toggle()
                        
                    }) {
                        Text("확인")
                            .font(.headline)
                    }
                    .frame(width: 257, height: 52)
                    .background(LinearGradient.alertAccept)
                    .foregroundColor(.white)
                    .cornerRadius(17)
                }
                .frame(width: 302, height: 328)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(17)
            }
            //            .ignoresSafeArea(.all)
            //                    .frame(
            //                        width: UIScreen.main.bounds.size.width,
            //                        height: UIScreen.main.bounds.size.height,
            //                        alignment: .center
            //                    )
        }}
}
    
//    #Preview {
//        AlertView(image: "alertImage/Image", title: "OO이가 배불러요!", message: "감사의 춤을 추고 있어요!")
//    }
