//
//  MyPageView.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/15/24.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        VStack(spacing: 40) {
            Profile()            
            Divider()
//            AppDetail()
//            Divider()
            Logout()
            
            Spacer()
        }.padding()
        
    }
}

#Preview {
    MyPageView()
}
