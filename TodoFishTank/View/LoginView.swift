import SwiftUI
import GoogleSignInSwift
import _AuthenticationServices_SwiftUI
import FirebaseAuth
import KakaoSDKUser

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack{
            Spacer()
            Image("loading")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            Spacer()
            
            Button(action: {
                authViewModel.kakaoLogin()
            }) {
                HStack {
                    Image(systemName: "message.fill") // Kakao 로고 대체 (원하는 로고로 변경)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                    Text("카카오 로그인")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 44)
                .background(Color(hex:"#FEE500"))
                .cornerRadius(12)
            }
            
            
            AppleSigninButton()
            
            Button(action: {
                authViewModel.googleLogin()
            }) {
                HStack {
                    Image("google_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("Google로 로그인")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 44)
                .background(Color.white)
                .cornerRadius(12)
            }
            
            HStack {
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
                
                Text("또는")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            
            
            Button(action: {
                authViewModel.signInAnonymously()
            }) {
                HStack {
                    Text("비회원으로 시작하기")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 44)
                .background(LinearGradient.categoryBadge)
                .cornerRadius(12)
            }
            
            
            
        }.background(Background())
        
        
        
    }
    
    struct AppleSigninButton : View{
        @EnvironmentObject var authViewModel: AuthViewModel
        var body: some View{
            HStack {
                Image(systemName: "apple.logo")
                Text("Apple로 로그인")
                    .font(.headline)
                    .fontWeight(.bold)
                    .font(.system(size: 19))
            }
            .frame(width : UIScreen.main.bounds.width * 0.9, height: 44)
            .foregroundStyle(Color.white)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 12)).overlay{
                SignInWithAppleButton { (request) in
                    authViewModel.nonce = authViewModel.randomNonceString()
                    request.requestedScopes = [.email, .fullName]
                    request.nonce = authViewModel.sha256(authViewModel.nonce)
                    
                } onCompletion: { (result) in
                    switch result {
                    case .success(let user):
                        print("success")
                        guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                            print("error with firebase")
                            return
                        }
                        authViewModel.authenticate(credential: credential)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .blendMode(.color)
            }
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}
