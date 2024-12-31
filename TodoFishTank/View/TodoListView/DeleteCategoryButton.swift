//
//  DeleteCategoryButton.swift
//  TodoFishTank
//
//  Created by 양재현 on 10/5/24.
//

import SwiftUI

struct DeleteCategoryButton: View {
    var body: some View {
            Image(systemName: "minus.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.red)
    
    }
}

#Preview {
    DeleteCategoryButton()
}
