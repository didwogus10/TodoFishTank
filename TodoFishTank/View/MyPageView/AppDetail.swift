//
//  AppDetail.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/15/24.
//

import SwiftUI

struct AppDetail: View {
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 35){
                Button(action: {}) {
                    Text("이용약관")
                        .font(.system(size: 15))
                }.buttonStyle(.plain)
                Button(action: {}) {
                    Text("문의하기")
                        .font(.system(size: 15))
                }.buttonStyle(.plain)
                Button(action: {}) {
                    Text("정보")
                        .font(.system(size: 15))
                }.buttonStyle(.plain)
                Button(action: {}) {
                    Text("버전")
                        .font(.system(size: 15))
                }.buttonStyle(.plain)
            }
            Spacer()
        }
    }
}

#Preview {
    AppDetail()
}
