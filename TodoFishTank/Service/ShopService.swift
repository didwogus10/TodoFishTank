import Foundation
import FirebaseFirestore
import FirebaseAuth

class ShopService {
    private var db = Firestore.firestore()
    
    //유저가 보유햔 Item들 가져오기
    func fetchShopItem() async throws -> [Item] {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw ShopServiceError.missingUserID
        }
        do {
            let querySnapshot = try await db.collection("shopItem")
                .whereField("userId", isEqualTo: uid)
                .order(by: "createdAt", descending: false) // 시간순으로 정렬
                .getDocuments()
            print("shopItem 불러오기 성공")
            return querySnapshot.documents.compactMap { document in
                try? document.data(as: Item.self)
            }
        } catch {
            print("shopItem 불러오기 오류: \(error)")
            throw ShopServiceError.firestoreError("Failed to fetch shopItems.")
        }
    }
    //샵아이템 구매
    func addShopItem(item: Item) -> Item? {
        let collectionRef = db.collection("shopItem")
        do {
            let newDocReference = try collectionRef.addDocument(from: item)
            var newItem = item
            newItem.id = newDocReference.documentID
            newItem.createdAt = Timestamp(date: Date())
            print("shopItem 저장됨: \(newDocReference)")
            return newItem
        }
        catch {
            print("shopItem 추가중 에러뜸 : \(error)")
            return nil
        }
    }
    //구매한 아이템 커스텀 기능
    func updateShopItem(items: [Item]) async throws {
         await withTaskGroup(of: Void.self) { group in
            for item in items {
                guard let itemId = item.id else { continue }
                guard let position = item.position else { continue }
                guard let scale = item.scale else { continue }

                // 병렬로 실행될 각 작업을 TaskGroup에 추가
                group.addTask {
                    do {
                        try await self.db.collection("shopItem").document(itemId).updateData([
                            "position": [position.width, position.height],
                            "scale": scale,
                            "isVisible": item.isVisible
                        ])
                        print("ShopItem \(itemId) 업데이트 완료")
                    } catch {
                        print("Error updating shopItem \(itemId): \(error)")
                    }
                }
            }
        }
    }

   
    
   
}
enum ShopServiceError: Error {
    case missingUserID
    case firestoreError(String)
}
