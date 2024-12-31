//
//  Background.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/12/24.
//

import SwiftUI

struct Background: View {
    @State private var showFirstImage = true
        let timer = Timer.publish(every: 7.0, on: .main, in: .common).autoconnect()
        
        var body: some View {
            ZStack {
                if showFirstImage {
                    Image("background") // 첫 번째 이미지
                        .transition(.opacity) // 이미지 전환 효과
                } else {
                    Image("background2") // 두 번째 이미지
                        .transition(.opacity)
                }
            }
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 7.0)) {
                    showFirstImage.toggle()
                }
            }
            
        }
    }
        
    

#Preview {
    Background()
}
