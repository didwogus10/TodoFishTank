//
//  ShopView.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/19/24.
//

import SwiftUI

struct ShopView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var shopViewModel: ShopViewModel
    @State private var accumulatedOffset = CGSize.zero
    @State private var magnifyBy: CGFloat = 1.0
    @State private var isShowAlertBuy : Bool = false
    @State private var isLackPointAlert : Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    
                    if shopViewModel.isEditMode
                    {
                        Button("shop") {
                            shopViewModel.isEditMode.toggle()
                        }.foregroundColor(.red)
                    }
                    
                    Spacer()
                    Button(shopViewModel.isEditMode ? "저장" : "내 아이템") {
                        Task {
                            if shopViewModel.isEditMode {
                                // 편집 모드에서 빠져나갈 때 업데이트 수행
                                try await shopViewModel.updateShopItem()
                            }
                            shopViewModel.isEditMode.toggle()
                            shopViewModel.selectedItem = nil
                        }
                    }.foregroundColor(.black)
                    
                    
                }.zIndex(1)
                Spacer()
                    ZStack {
                        FishImage(isFixed: shopViewModel.isEditMode ? false : true)
                            .frame(height: UIScreen.main.bounds.height / 3)
                        // 선택된 이미지가 있으면 화면에 배치
                        if let shopItem = shopCategories.first(where: { $0.id == shopViewModel.selectedCategory })?.shopItems.first(where: { $0.id == shopViewModel.selectedItem }) {
                        
                            ItemImage(accumulatedOffset: $accumulatedOffset, magnifyBy: $magnifyBy, path: shopItem.path)
                                .frame(height: UIScreen.main.bounds.height / 3)
                        }
                    }
                
                
                //어떤 아이템도 선택안했으면 버튼 비활성화, 구매누르면 다시 초기화
                if let shopItem = shopCategories.first(where: { $0.id == shopViewModel.selectedCategory })?.shopItems.first(where: { $0.id == shopViewModel.selectedItem }) {
                    
                    Button("구매") {
                        isShowAlertBuy = true
                        
                    }
                    .foregroundColor(.black)
                    .alert("구매하기", isPresented: $isShowAlertBuy) {
                        Button("취소") { }
                        Button("확인") {
                            Task{
                                if let userPoint = userViewModel.user?.point {
                                    if userPoint >= 300 {
                                         shopViewModel.addShopItem(item: Item(path: shopItem.path, position: accumulatedOffset, scale: magnifyBy, userId: userViewModel.user?.id))
                                        try await userViewModel.payPoint(point: 300)
                                        shopViewModel.selectedItem = nil
                                        dismiss()
                                        
                                    }
                                    else {
                                        isLackPointAlert = true
                                        print("포인트가 부족합니다")
                                    }
                                }
                            }
                            
                        }
                        
                        
                    } message: {
                        Text("포인트를 주고 구매하시겠습니까?")
                    }.alert("알림", isPresented: $isLackPointAlert) {
                        Button("확인"){}
                    }message: {
                        Text("포인트가 부족합니다.")
                    }
                }
                Spacer()
                if !shopViewModel.isEditMode{
                    ShopCategoryRow()
                }
                ShopGrid()
            }
            
        }
        
        .background(Background())
        .padding()
        
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                })
                //수정된 내용이 있어요! 저장할까요 ?
                
            }
            ToolbarItem(placement: .topBarTrailing) {
                Badge(circleColor: .yellow, text: "\(userViewModel.user?.point ?? 0)p")
            }
        }

        
    }
    
}


#Preview {
    ShopView()
        .environmentObject(UserViewModel(userService: UserService()))
        .environmentObject(ShopViewModel(shopService: ShopService()))
}
