import Foundation
import FirebaseFirestore

struct Item: Identifiable, Codable {
    @DocumentID var id: String?
    var path: String
    var position: CGSize?
    var scale: CGFloat?
    var userId: String?
    var isVisible: Bool = true
    @ServerTimestamp var createdAt: Timestamp?
}


@MainActor
class ShopViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var selectedCategory: Int = 1
    @Published var selectedItem: String? //shopITem
    @Published var isEditMode: Bool = false
    
    @Published var errorMessage: String?
    
    
    let shopService: ShopService
    
    init(shopService: ShopService) {
        self.shopService = shopService
    }
    
    //데이터 받아오기
    func fetchShopItem() async throws {
       items = try await shopService.fetchShopItem()
    }
    //아이템추가
    func addShopItem(item: Item) {
        guard let newItem = shopService.addShopItem(item: item) else {
            return
        }
        items.append(newItem)
    }
    //아이템 위치, 스케일 업데이트 //병렬로 처리해보기 withTaskGroup(of:body:)!!!!!!!!!
    func updateShopItem() async throws {
        try await shopService.updateShopItem(items: items)
        for item in items{
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                items[index] = item
            }
        }
    }
    
    //보이냐 안보이냐
    func modifyVisible(item : Item) {
        guard let itemId = item.id else { return }
        if let index = items.firstIndex(where: { $0.id == itemId }) {
            items[index].isVisible.toggle()
        }
    }
    
    
}


