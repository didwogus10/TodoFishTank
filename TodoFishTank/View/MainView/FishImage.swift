import SwiftUI

struct FishImage: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var shopViewModel: ShopViewModel
    
    var isFixed : Bool
    var body: some View {
        //         단계별로 크기 설정-> 퍼센트로 설정
        var width: CGFloat = 140
        switch userViewModel.fishLevel {
        case 1:
            width *= 1
        case 2:
            width *= 1.03
        case 3:
            width *= 1.35
        case 4:
            width *= 1.71
        case 5:
            width *= 1.78
        default:
            width *= 1.78 // 기본 크기
        }
        //140, 145, 190, 240, 250
        
        return ZStack {
            Image("growthLevel/\(userViewModel.fishLevel)")
                .resizable()
                .aspectRatio(contentMode: .fit) //크기가 커져도 비율 유지
                .frame(width: width)
            ForEach(shopViewModel.items) { item in
                StyleImage(item: item, isFixed: isFixed)
            }
        }
    }
    
}


#Preview {
    FishImage(isFixed: false)
        .environmentObject(UserViewModel(userService: UserService()))
        .environmentObject(ShopViewModel(shopService: ShopService()))
}
