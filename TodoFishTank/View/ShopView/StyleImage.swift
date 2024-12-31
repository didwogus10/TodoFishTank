//
//  StyleImage.swift
//  TodoFishTank
//
//  Created by 양재현 on 11/26/24.
//

import SwiftUI

struct StyleImage: View {
    @EnvironmentObject var shopViewModel: ShopViewModel
    @State private var draggedOffset = CGSize.zero
    @State private var accumulatedOffset = CGSize.zero
    @State private var magnifyBy: CGFloat = 1.0
    
    
    var item: Item // 각 아이템의 데이터를 받는다.
    var isFixed : Bool
    
    var magnification: some Gesture {
        MagnifyGesture(minimumScaleDelta: magnifyBy)
            .onChanged { value in
                magnifyBy = value.magnification
            }
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                let maxOffset = CGSize(
                    width: (UIScreen.main.bounds.width / 2) - 20,  // 이미지 크기 고려
                    height: (UIScreen.main.bounds.height / 6) - 20
                )
                let minOffset = CGSize(
                    width: -(UIScreen.main.bounds.width / 2) + 20,
                    height: -(UIScreen.main.bounds.height / 6) + 20
                )
                
                let tentativeOffset = CGSize(
                    width: accumulatedOffset.width + value.translation.width,
                    height: accumulatedOffset.height + value.translation.height
                )
                
                draggedOffset = CGSize(
                    width: max(min(tentativeOffset.width, maxOffset.width), minOffset.width) - accumulatedOffset.width,
                    height: max(min(tentativeOffset.height, maxOffset.height), minOffset.height) - accumulatedOffset.height
                )
            }
            .onEnded { value in
                accumulatedOffset.width += draggedOffset.width
                accumulatedOffset.height += draggedOffset.height
                
                // item의 id로 직접 찾아서 수정
                if let index = shopViewModel.items.firstIndex(where: { $0.id == item.id }) {
                    
                    shopViewModel.items[index].position?.width += draggedOffset.width
                    shopViewModel.items[index].position?.height += draggedOffset.height
                }
                
                draggedOffset = .zero
                
                
                
            }
    }
    
    var body: some View {
        if item.isVisible{
            Image(item.path)
                .resizable()
                .aspectRatio(contentMode: .fit) // 크기가 커져도 비율 유지
                .frame(width: 100 * (item.scale ?? 1.0))
                .scaleEffect(isFixed ? 1.0 : (item.scale ?? 1.0))
            //                .scaleEffect(magnifyBy)
//                .gesture(isFixed ? nil : magnification)
                .offset(
                    x: accumulatedOffset.width + draggedOffset.width,
                    y: accumulatedOffset.height + draggedOffset.height
                )
                .simultaneousGesture(isFixed ? nil : drag)
                .onAppear {
                    // 초기화 시 item.position과 accumulatedOffset을 동기화
                    accumulatedOffset = CGSize(
                        width: item.position?.width ?? 0,
                        height: item.position?.height ?? 0
                    )
                }
            
        }
    }
}

#Preview {
    StyleImage(item: Item(path: "d"), isFixed: false)
        .environmentObject(ShopViewModel(shopService: ShopService()))
}
