//
//  TodoListView.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/13/24.
//

import SwiftUI

struct TodoListView: View {
    
    var body: some View {
        VStack(alignment: .leading){
            WeekCalendar()
            CategoryRow()
            ProgressBar()
            
            HStack {
                Spacer()
                EditBadge()
            }
            TodoList()
            
            Spacer()
        }
        
        .padding()
    }

}

#Preview {
    NavigationStack{
        TodoListView()}
}
