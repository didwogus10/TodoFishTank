//
//  MainView.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/13/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var shopViewModel: ShopViewModel
    
    var body: some View {
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack{
                        Spacer()
                        Badge(circleColor: .orange, text: "\(userViewModel.user?.foodCount ?? 0)")
                            
                        Badge(circleColor: .yellow, text: "\(userViewModel.user?.point ?? 0)p")
                    }.zIndex(1)
                    .padding(.bottom, 30)

                    FishImage(isFixed: true)
                        .padding(.bottom, 30)

                    FishCare()
                        .padding(.bottom, 30)
                    
                    WeekCalendar()
                        .padding(.bottom, 30)
                    PercentCard()
                    
                }
                .padding(32)
            }
            .background(Background())
        }
        
        
}

#Preview {
    MainView()
        .environmentObject(UserViewModel(userService: UserService()))
        .environmentObject(ShopViewModel(shopService: ShopService()))
        .environmentObject(TodoViewModel(todoService: TodoService()))
}
