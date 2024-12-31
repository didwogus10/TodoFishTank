import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var point: Int
    var foodCount: Int
    var feedCount: Int
    var lastPointDate: Date?
    var lastFeedDate: Date?
    @ServerTimestamp var createdAt: Timestamp?
}

@MainActor
class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var getPointAlert : Bool = false
    @Published var feedAlert : Bool = false
    @Published var payPointAlert : Bool = false
    @Published var alreadyFedAlert: Bool = false
    @Published var levelUpAlert: Bool = false
    @Published var errorMessage: String?
    
    var fishLevel: Int {
        guard let feedCount = user?.feedCount else { return 1 } // feedCount가 nil일 경우 레벨 1로 초기화
        switch feedCount {
        case 0:
            return 1
        case 1...4:
            return 2
        case 5...9:
            return 3
        case 10...14:
            return 4
        default:
            return 5 // 최대 성장 레벨
        }
    }
    
    let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    //현재 유저 데이터 받아오기
    func fetchCurrentUser() async throws{
        user = try await userService.fetchCurrentUser()
    }
    
    //먹이주기 기능
    func feed() async throws {
        guard let user = user else { return }
        let todayStart = Calendar.current.startOfDay(for: Date()) // 오늘 00:00
        if let lastFeedDate = user.lastFeedDate, lastFeedDate >= todayStart {
            alreadyFedAlert = true // 이미 먹이를 줬다는 알림
            return
        }
        let previousLevel = fishLevel // 현재 레벨을 저장
        try await userService.feed() //파이어베이스에 업뎃
        var newUser = user
        newUser.lastFeedDate = Date()
        newUser.foodCount -= 1
        newUser.feedCount += 1
        self.user = newUser //로컬에업데이트
        if fishLevel > previousLevel {
            levelUpAlert = true // 레벨 업 알림
        }
        feedAlert = true
    }
    
    //포인트획득
    func getPoint() async throws{
        guard let user = user else { return }
        let todayStart = Calendar.current.startOfDay(for: Date()) // 오늘 00:00
        
        if let lastPointDate = user.lastPointDate, lastPointDate >= todayStart {
            print("오늘 이미 포인트를 받았습니다.")
            return
        }
        try await userService.getPoint()
        var newUser = user
        newUser.lastPointDate = Date()
        newUser.point += 100
        newUser.foodCount += 1
        self.user = newUser //여기도 로컬에 추가해주기
        getPointAlert = true
    }
    //포인트 지불
    func payPoint(point : Int) async throws{
        guard let user = user else { return }
        try await userService.payPoint(point: point)
        var newUser = user
        newUser.point -= point
        self.user = newUser //여기도 로컬에 추가해주기
        payPointAlert = true
    }
}
