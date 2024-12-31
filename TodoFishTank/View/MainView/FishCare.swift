import SwiftUI

struct FishCare: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isLackFood: Bool = false
    
    var body: some View {
            VStack {
                HStack {
                    Text("\(userViewModel.user?.name ?? "회원")님의 어항")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                HStack {
                    Button(action: {
                        if let foodCount = userViewModel.user?.foodCount{
                            if foodCount > 0 {
                                Task {
                                   try await userViewModel.feed()
                                }
                            }else {
                                isLackFood = true
                            }
                        }
                    }) {
                        Text("밥 주기")
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // 버튼 전체가 클릭 가능
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.gray)
                    .alert("알림", isPresented: $isLackFood) {
                        Button("확인"){}
                    }message: {
                        Text("먹이가 부족합니다.")
                    }
                    

                    Divider()
                    
                    NavigationLink(destination: ShopView()) {
                        Text("shop")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.gray)
                }
                .frame(height: 36) 
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white.opacity(0.75))
                    .shadow(color: Color(hex: "#5A33AC").opacity(0.31), radius: 12.1, x: 0, y: 4)
                
            )

        }
    }

#Preview {
    NavigationStack {
        FishCare()
    }
    .environmentObject(UserViewModel(userService: UserService()))
}
