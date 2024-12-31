import Foundation
import CryptoKit
import AuthenticationServices
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import KakaoSDKUser
import KakaoSDKAuth

class AuthViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    @Published var isLoggedIn: Bool = false // 로그인 상태 관리
    @Published var isLoading: Bool = true //로딩여부
    @Published var isAnonymous: Bool = false //익명로그인지 여부
    @Published var nonce : String = ""
    
    override init() {
        super.init()
        checkLoginStatus()
    }
    //로그인 상태여부 -----------------
    func checkLoginStatus() {
        _ = Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.isLoggedIn = true
                self.isLoading = false
                self.checkIfAnonymousUser()
                print("Auth state changed, is signed in")
            } else {
                self.isLoggedIn = false
                self.isLoading = false
                print("Auth state changed, is signed out")
            }
        }
    }
    //익명 로그인 --------
    func signInAnonymously() {
        Auth.auth().signInAnonymously { authResult, error in
            if (error != nil) {
               print("익명로그인 실패")
                return
            } else {
                //회원가입할때 database도 같이생성 user데이타베이스
                self.createDatabase(user: User(name: "비회원", point: 0, foodCount: 0, feedCount: 0))
            }
        }
        
    }
    //악명로그인지 체크
    func checkIfAnonymousUser() {
        if let user = Auth.auth().currentUser {
            if user.isAnonymous {
                isAnonymous = true
                print("현재 사용자는 비회원(익명 로그인)입니다.")
            } else {
                isAnonymous = false
                print("현재 사용자는 정회원(계정 로그인)입니다.")
            }
        } else {
            isAnonymous = false
            print("현재 로그인된 사용자가 없습니다.")
        }
    }
    
    
    //카카오 로그인-------------------------
    func kakaoLogin() {
        kakaoAuthSignIn()
    }
    func kakaoAuthSignIn() {
        if AuthApi.hasToken() { // 발급된 토큰이 있는지
            UserApi.shared.accessTokenInfo { _, error in // 해당 토큰이 유효한지
                if error != nil { // 에러가 발생했으면 토큰이 유효하지 않다.
                    self.openKakaoService()
                } else { // 유효한 토큰
                    self.loadInfoDidKakaoAuth()
                }
            }
        } else { // 만료된 토큰
            self.openKakaoService()
        }
    }
    
    //카카오톡 앱/웹 로그인여부
    func openKakaoService() {
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    print("카카오톡 로그인 success")
                    
                    // 추가작업 -> firebase login까지
                    _ = oauthToken
                    self.loadInfoDidKakaoAuth()
                }
            }
        } else {
            // 카카오계정 로그인
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    print("카카오계정 로그인 success")
                    
                    // 추가작업
                    _ = oauthToken
                    self.loadInfoDidKakaoAuth()
                }
            }
        }
    }
    //카카오톡 사용자 정보 불러오기
    func loadInfoDidKakaoAuth() {
        UserApi.shared.me { kakaoUser, error in
            if error != nil {
                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                return
            }
            guard let userEmail = kakaoUser?.kakaoAccount?.email else { return }
            guard let userName = kakaoUser?.kakaoAccount?.profile?.nickname else { return }
            guard let userId = kakaoUser?.id else { return }
            
            self.firebaseLogin(userEmail: userEmail, userName: userName, userId: "\(userId)")
        }
    }
    
    
    //firebase 회원가입/로그인
    func firebaseLogin(userEmail: String, userName: String, userId: String) {
        Auth.auth().createUser(withEmail: userEmail,
                               password: "\(String(describing: userId))") { result, error in
            //이미 계정있다면 로그인시도
            if error != nil {
                Auth.auth().signIn(withEmail: userEmail,
                                   password: "\(String(describing: userId))")
            } else {
                //회원가입할때 database도 같이생성 user데이타베이스
                self.createDatabase(user: User(name: userName, point: 0, foodCount: 0, feedCount: 0))
                print("DEBUG: 파이어베이스 사용자 생성")
            }
        }
    }
    //처음 계정말들때 추가할거------------------------
    private func createDatabase(user: User) {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else{
            print("데이터베이스 생성실패 : uid없는듯")
            return
        }
        do {
            try db.collection("user").document(uid).setData(from: user)
            print("데이터베이스 생성완료!")
        } catch {
            print("데이터베이스 생성실패: \(error)")
        }
    }
    
    //로그아웃------------------------
    func logout() {
        // 1. 카카오 로그아웃
        UserApi.shared.logout { error in
            if let error = error {
                print("카카오 로그아웃 실패: \(error.localizedDescription)")
            } else {
                print("카카오 로그아웃 성공")
            }
        }
        
        // 2. Google 로그아웃
        GIDSignIn.sharedInstance.signOut()
        print("Google 로그아웃 성공")
        
        
        // 3. Firebase 로그아웃
        do {
            try Auth.auth().signOut()
            print("Firebase 로그아웃 성공")
        } catch {
            print("Firebase 로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
    
    //회원탈퇴---------------
    func deleteUser() async throws{
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "현재 사용자를 찾을 수 없습니다."])
        }
        // 로그인 제공자 확인
        let providerID = user.providerData.first?.providerID ?? ""
        print("DEBUG: 로그인 제공자 - \(providerID)")
        
        // 로그인 제공자에 따른 추가 처리
        switch providerID {
        case "google.com":
            //구글 탈퇴
            try await deleteGoogle()
        case "apple.com":
            deleteCurrentUser() //애플 탈퇴
            
        default:
            ////카카오탈퇴
            try await deleteKakao()
            print("DEBUG: 기타 로그인 제공자 \(providerID)")
        }
    }
    // 구글탈퇴
    func deleteGoogle() async throws {
        guard let user = Auth.auth().currentUser else {
            return
        }
        GIDSignIn.sharedInstance.signOut() //구글 로그아웃
        try await user.delete() //파이어베이스 삭제
    }
    // 카카오 탈퇴
    func deleteKakao() async throws {
        guard let user = Auth.auth().currentUser else {
            return
        }
        UserApi.shared.unlink { error in
            if let error = error {
                print("카카오 토큰 삭제 실패: \(error.localizedDescription)")
            } else {
                print("카카오 토큰 삭제 성공")
            }
        }
        try await user.delete() //파이어베이스 삭제
    }
    
    
    //구글로그인 ---------
    func googleLogin() {
        // FirebaseApp에서 clientID 가져오기 및 구성 설정
        if let clientID = FirebaseApp.app()?.options.clientID {
            let signInConfig = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = signInConfig
        } else {
            print("Error: ClientID not found in FirebaseApp.")
            return
        }
        
        // 이전의 로그인정보있다?
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                // 2
                guard let accessToken = user?.accessToken.tokenString, let idToken = user?.idToken?.tokenString else { return }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                // 3
                Auth.auth().signIn(with: credential) { (_, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                    }
                }
            }
        } else { // 처음 회원가입이다?
            // 현재 앱의 rootViewController 가져오기
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                print("Error: Unable to get rootViewController.")
                return
            }
            
            // 회원가입 ㄱㄱ
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
                // 1. 에러 처리
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                // 2. 결과 확인 및 Firebase 인증 처리
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString,
                      let userName = user.profile?.name
                else { // 옵셔널 바인딩
                    print("Error: Missing user, ID token, or access token.")
                    return
                }
                let accessToken = user.accessToken.tokenString
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                //처음 회원가입
                Auth.auth().signIn(with: credential) { (result, error) in
                    let isNewUser = result?.additionalUserInfo?.isNewUser ?? false
                    if isNewUser {
                        // 새로운 계정인 경우에만 데이터베이스 생성
                        self.createDatabase(user: User(name: userName, point: 0, foodCount: 0, feedCount: 0))
                        print("DEBUG: 새로운 사용자로 데이터베이스 생성")
                        
                    } else {
                        print("DEBUG: 기존 사용자 로그인")
                    }
                }
                
                
            }
        }
    }
    
    // Apple 로그인------------------------------------------------------------------
    func authenticate(credential: ASAuthorizationAppleIDCredential) {
        //getting token
        guard let token = credential.identityToken else {
            print("error with firebase")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with token")
            return
        }
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        let fullName = credential.fullName
        let userName =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "회원")
        
        
        Auth.auth().signIn(with: firebaseCredential) { result, err in
            if let err = err {
                print(err.localizedDescription)
            }
            guard let user = result?.user else { return }
            let isNewUser = result?.additionalUserInfo?.isNewUser ?? false
            
            if isNewUser {
                
                // Display Name 설정 -> 나중에 설정필요 displayname을 쓰는곳?
                let changeRequest = result?.user.createProfileChangeRequest()
                changeRequest?.displayName = userName
                changeRequest?.commitChanges { error in
                    if let error = error {
                        print("DEBUG: Display name 설정 실패 \(error.localizedDescription)")
                    } else {
                        print("DEBUG: Display name 설정 완료 ")
                    }
                }
                // 새로운 계정인 경우에만 데이터베이스 생성
                self.createDatabase(user: User(name: userName, point: 0, foodCount: 0, feedCount: 0))
                print("DEBUG: 새로운 사용자로 데이터베이스 생성")
            } else {
                print("DEBUG: 기존 사용자 로그인")
            }
        }
    }
    
    // Helper for Apple Login with Firebase
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    
    //애플 회원탈퇴
    private func deleteCurrentUser() {
        
        let nonce = randomNonceString()
        self.nonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            authorizationController.presentationContextProvider = keyWindow.rootViewController as? ASAuthorizationControllerPresentationContextProviding
        }
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
        else {
            print("Unable to retrieve AppleIDCredential")
            return
        }
        
        guard let appleAuthCode = appleIDCredential.authorizationCode else {
            print("Unable to fetch authorization code")
            return
        }
        
        guard let authCodeString = String(data: appleAuthCode, encoding: .utf8) else {
            print("Unable to serialize auth code string from data: \(appleAuthCode.debugDescription)")
            return
        }
        
        
        
        Task {
            do {
                // Apple에서 받은 IDToken과 nonce를 사용하여 새로운 Apple 자격 증명을 만듭니다.
                let credential = OAuthProvider.credential(
                    withProviderID: "apple.com",
                    idToken: String(data: appleIDCredential.identityToken!, encoding: .utf8)!,
                    rawNonce: nonce
                )
                guard let user = Auth.auth().currentUser else { return }
                try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
                print("토큰 취소 완료")
                try await user.reauthenticate(with: credential)
                print("재인증 성공")
                
                try await user.delete()
                print("사용자 계정 삭제 완료")
            } catch {
                print("토큰 취소 실패: \(error)")
            }
        }
    }
    
}
