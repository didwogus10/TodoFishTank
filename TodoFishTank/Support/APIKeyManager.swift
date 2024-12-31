//
//  AppKey.swift
//  TodoFishTank
//
//  Created by 양재현 on 12/30/24.
//

import Foundation

struct APIKeyManager {
    static var kakaoAppKey: String {
        guard let path = Bundle.main.path(forResource: "Secret", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["KakaoAppKey"] as? String else {
            fatalError("Secret.plist not found or API_KEY not set")
        }
        return key
    }
}

let kakaoAppKey = APIKeyManager.kakaoAppKey
