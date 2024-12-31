import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var todoViewModel: TodoViewModel
    @EnvironmentObject var shopViewModel: ShopViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack{
            ZStack {
                TabView(selection: $selectedTab) {
                    MainView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("홈")
                        }
                        .tag(0)
                    TodoListView()
                        .tabItem {
                            Image(systemName: "note.text.badge.plus")
                            Text("할일 추가")
                        }
                        .tag(1)
                    
                    
                    MyPageView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("내 정보")
                        }
                        .tag(2)
                    
                }
                .accentColor(Color(hex: "#FF6F0F"))
                
                if userViewModel.getPointAlert  {
                    AlertView(isAlertShow: $userViewModel.getPointAlert, image: "alertImage/point", title: "포인트를 받았어요!", message: "어항이 풍족해졌어요!"
                    )
                }
                if userViewModel.feedAlert  {
                    AlertView(isAlertShow: $userViewModel.feedAlert, image: "alertImage/feed", title: "물고기가 배불러요!", message: "감사의 춤을 추고 있어요!"
                    )
                }
                if userViewModel.payPointAlert  {
                    AlertView(isAlertShow: $userViewModel.payPointAlert, image: "alertImage/pay", title: "구매를 완료했어요!", message: "어항이 더 아름다워졌어요!"
                    )
                }
                if userViewModel.alreadyFedAlert  {
                    AlertView(isAlertShow: $userViewModel.alreadyFedAlert, image: "alertImage/feed", title: "오늘 이미 먹이를 줬어요!", message: "물고기가 이미 배불러요!"
                    )
                }
                if userViewModel.levelUpAlert  {
                    AlertView(isAlertShow: $userViewModel.levelUpAlert, image: "growthLevel/\(userViewModel.fishLevel)", title: "물고기가 성장했어요!", message: "계속 잘 성장시켜봐요!"
                    )
                }
                
            }
            
            
        }.task {
            do {
                try await userViewModel.fetchCurrentUser()
                try await todoViewModel.fetchCategories()
                try await todoViewModel.fetchTodoList()
                try await shopViewModel.fetchShopItem()
                print("데이터 로드 완료")
            } catch {
                print("데이터 로드 실패: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack{
        ContentView()
    }
    .environmentObject(UserViewModel(userService: UserService()))
    .environmentObject(TodoViewModel(todoService: TodoService()))
    .environmentObject(ShopViewModel(shopService: ShopService()))
}
