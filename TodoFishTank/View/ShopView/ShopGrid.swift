    //
    //  ShopGrid.swift
    //  TodoFishTank
    //
    //  Created by 양재현 on 9/19/24.
    //

    import SwiftUI

    struct ShopGrid: View {
        @EnvironmentObject var shopViewModel: ShopViewModel
        
        var body: some View {
            let columns = [GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible())]
            let shopItems = shopCategories.first(where: {$0.id == shopViewModel.selectedCategory})?.shopItems ?? []

                ScrollView{
                    ZStack() {
                        Spacer().containerRelativeFrame([.vertical])
                        LazyVGrid(columns: columns, alignment: .center, spacing: 50) {
                            
                            ForEach(shopViewModel.isEditMode ? shopViewModel.items : shopItems) { item in
                                VStack() {
                                    Image(item.path)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 50, maxHeight: 50)
                                        .onTapGesture {
                                            if shopViewModel.isEditMode {
                                                shopViewModel.modifyVisible(item: item)
                                            }
                                            else {
                                                shopViewModel.selectedItem = item.id
                                            }
                                        }
//                                   Spacer()
                                    HStack(spacing: 1){
                                            Circle()
                                                .fill(.yellow)
                                                .frame(width: 11, height: 11)
                                            
                                            Text("300").font(.system(size: 11))
                                     
                                    }
                                }
                            }
                        }
                    }
                    
                }
    //            .scrollDisabled(!shopViewModel.isEditMode)
                .frame(height: UIScreen.main.bounds.height / 2.5)
                .background(.white.opacity(0.49))
                .cornerRadius(19)
                .overlay(
                    RoundedRectangle(cornerRadius: 19)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 1)
                )
        }
    }

    #Preview {
        ShopGrid()
            .environmentObject(ShopViewModel(shopService: ShopService()))
    }
