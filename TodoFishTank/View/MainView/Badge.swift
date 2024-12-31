//
//  BadgeView.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/12/24.
//

import SwiftUI

struct Badge: View {
    var circleColor : Color
    var text : String
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(circleColor)
                .frame(width: 17, height: 17)
            Text(text)
                .font(.system(size: 13))
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 34)
            .stroke(Color.gray, lineWidth: 1)
            .fill(.white)
        )
        
    }
}

#Preview {
    Badge(
        circleColor: .orange, text: "10"
    )
}
