//
//  TodoFishTankApp.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/12/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct TodoFishTankApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var userViewModel = UserViewModel(userService: UserService())
    @StateObject private var todoViewModel = TodoViewModel(todoService: TodoService())
    @StateObject private var shopViewModel = ShopViewModel(shopService: ShopService())
    
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            Group{
                if authViewModel.isLoading {
                    LoadingView()
                } else{
                    if authViewModel.isLoggedIn {
                        ContentView()
                            
                    } else {
                        LoginView()
                    }
                }
            }.onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            })
        }
        .environmentObject(authViewModel)
        .environmentObject(userViewModel)
        .environmentObject(todoViewModel)
        .environmentObject(shopViewModel)
    }
   
}
