import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserService {
    private var db = Firestore.firestore()
    
    //현재 유저 데이터 받아오기
    func fetchCurrentUser() async throws -> User? {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw UserServiceError.missingUserID
        }
        
        let docRef = db.collection("user").document(uid)
        return try await docRef.getDocument(as: User.self)
    }
    //먹이주기
    func feed() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw UserServiceError.missingUserID
        }
        do {
             try await db.collection("user").document(uid).updateData([
                "lastFeedDate" : FieldValue.serverTimestamp(),
                "foodCount": FieldValue.increment(Int64(-1)),
                "feedCount": FieldValue.increment(Int64(1))
            ])
            print("먹이 데이터 업데이트") //나중에 데이터 받아오기, 로딩중 먹이먹는중... 추가
        } catch {
            print("먹이주기 오류: \(error)")
        }
    }
    //포인트 받기
    func getPoint() async throws{
        guard let uid = Auth.auth().currentUser?.uid else {
            throw UserServiceError.missingUserID
        }
        do {
            try await db.collection("user").document(uid).updateData([
                "lastPointDate" : FieldValue.serverTimestamp(),
                "point" : FieldValue.increment(Int64(100)),
                "foodCount" : FieldValue.increment(Int64(1))
            ])
            print("포인트받은날짜 업데이트")
        } catch {
            print("포인트받기중 오류: \(error)")
        }
        
    }
    //포인트 지불
    func payPoint(point : Int) async throws{
        guard let uid = Auth.auth().currentUser?.uid else {
            throw UserServiceError.missingUserID
        }
        do {
            try await db.collection("user").document(uid).updateData([
                "point" : FieldValue.increment(Int64(-point)),
            ])
            print("포인트 지불")
        } catch {
            print("포인트지불중 오류: \(error)")
        }
        
    }
    
   
}
enum UserServiceError: Error {
    case missingUserID
    case firestoreError(String)
}
