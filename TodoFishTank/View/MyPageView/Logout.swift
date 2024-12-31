//
//  Logout.swift
//  TodoFishTank
//
//  Created by 양재현 on 9/15/24.
//

import SwiftUI

struct Logout: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isShowAlertLogOut:Bool = false
    @State private var isShowAlertDelete:Bool = false
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 28){
                //로그아웃
                Button(action: {
                    isShowAlertLogOut = true
                }) {
                    Text("로그아웃")
                        .font(.system(size: 15))
                        .underline()
                        .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                    
                    
                    
                }.buttonStyle(.plain)
                    .alert("로그아웃", isPresented: $isShowAlertLogOut) {
                        Button("취소") { }
                        Button("확인") { authViewModel.logout()}
                    } message: {
                        Text(
                            authViewModel.isAnonymous ? "비회원으로 로그인 중입니다.\n 로그아웃 시 데이터를 복구할 수 없습니다.\n 정말 로그아웃하시겠습니까?" :
                            "로그아웃 하시겠습니까?")
                    }
                //탈퇴
                Button(action: {
                    isShowAlertDelete = true
                }) {
                    Text("회원탈퇴")
                        .font(.system(size: 15))
                        .underline()
                        .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                    
                    
                    
                }.buttonStyle(.plain)
                    .alert("회원탈퇴", isPresented: $isShowAlertDelete) {
                        
                        Button("취소") { }
                        Button("확인") {
                            Task{
                                try await authViewModel.deleteUser()
                            }
                        }
                        
                        
                    } message: {
                        VStack{
                            Text("정말로 탈퇴하시겠습니까?\n모든 정보가 삭제됩니다.")
                        }
                    }
            }
            Spacer()
        }
    }
   
}

#Preview {
    Logout().environmentObject(AuthViewModel())
}
