import Foundation

// 샵 카테고리
struct ShopCategory : Identifiable{
    var id : Int
    var name: String
    var shopItems : [Item]
}

//만약 선택한 이미지가 다르다면 이미지 path를 하나 더만들고 사이즈도 더 만들고
let shopCategories: [ShopCategory] = [
    ShopCategory(id: 1, name: "꾸미기", shopItems: (1...9).map {
        Item(id: UUID().uuidString, path: "shop/style/\($0)")
    }),
    ShopCategory(id: 2,name: "자갈바위",  shopItems: (1...8).map {
        Item(id: UUID().uuidString, path: "shop/gravelRock/\($0)")
    }),
    ShopCategory(id: 3,name: "해초",  shopItems: (1...9).map {
        Item(id: UUID().uuidString, path: "shop/seaWeeds/\($0)")
    }),
    ShopCategory(id: 4,name: "친구들",  shopItems: (1...6).map {
        Item(id: UUID().uuidString, path: "shop/seaFriends/\($0)")
    }),
    ShopCategory(id: 5,name: "스페셜", shopItems: (1...5).map {
        Item(id: UUID().uuidString, path: "shop/special/\($0)")
    }),
//    ShopCategory(id: 6,name: "배경효과", shopItems: [
//    ])
]
