import Foundation
import FirebaseFirestore
import FirebaseAuth

class TodoService {
    private var db = Firestore.firestore()
    
    //투두리스트 ----------
    func fetchTodoList() async throws -> [Todo]{
        guard let uid = Auth.auth().currentUser?.uid else{
            throw TodoServiceError.missingUserID
        }
        // 이번 주의 날짜 범위 가져오기
        let (startOfWeek, endOfWeek) = DateHelper.weekRange()
        
        do {
            let querySnapshot = try await db.collection("todoList")
                .whereField("userId", isEqualTo: uid)
                .whereField("createdAt", isGreaterThanOrEqualTo: Timestamp(date: startOfWeek))
                .whereField("createdAt", isLessThanOrEqualTo: Timestamp(date: endOfWeek))
                            .order(by: "createdAt", descending: false) // 시간순으로 정렬 -> 안되면 로컬에서 정렬

                .getDocuments()
            print("투두리스트 불러오기 성공")
            return querySnapshot.documents.compactMap { document in
              try? document.data(as: Todo.self)
            }
        } catch {
            print("투두가져오기 오류: \(error)")
            throw TodoServiceError.firestoreError("Failed to fetch todos.")
                    
        }
    }
    func addTodo(todo: Todo) -> Todo? {
        let collectionRef = db.collection("todoList")
        
        do {
            let newDocReference = try collectionRef.addDocument(from: todo)
            
            //그냥 로컬에 저장하면 id, createdAt이 nil이여서 이렇게저장 // 원래라면 추가하자마자 데이터를 받아와야하나?
            var newTodo = todo
            newTodo.id = newDocReference.documentID
            newTodo.createdAt = Timestamp(date: Date())
            print("투두 추가 완료")
            return newTodo
        }
        catch {
            print("투두리스트 추가중 에러뜸 \(error)")
            return nil
        }
    }
    
    func modifyTodoDone(todo: Todo) async throws {
        guard let todoId = todo.id else { return }
        do {
            try await db.collection("todoList").document(todoId).updateData([
                "isComplete": !todo.isComplete
            ])
            print("할일 토글 업데이트")
        } catch {
            print("isComplete 업데이트 오류: \(error)")
        }
    }
    
    func deleteTodo(todo:Todo) async throws {
        guard let todoId = todo.id else { return }
        do {
            try await db.collection("todoList").document(todoId).delete()       
            print("투두삭제완료!")
        } catch {
            print("투두삭제오류 : \(error)")
        }
    }
    func updateTodo(todo:Todo) async throws {
        guard let todoId = todo.id else { return }
        do {
            try await db.collection("todoList").document(todoId).updateData([
                "title" : todo.title //현재로썬 title밖에 바꿀게없네
            ])
            print("투두 업데이트")
        } catch {
            print("투두 업데이트오류 : \(error)")
        }
    }
    //카테고리 -------------
    func fetchCategories() async throws -> [TodoCategory]{
        guard let uid = Auth.auth().currentUser?.uid else{
            throw TodoServiceError.missingUserID
        }
        do {
            let querySnapshot = try await db.collection("categories")
                .whereField("userId", isEqualTo: uid)
                .order(by: "createdAt", descending: false) // 시간순으로 정렬 색인어쩌고 설정해야함
                .getDocuments()
            print("카테고리 불러오기 성공")
           return querySnapshot.documents.compactMap { document in
                try? document.data(as: TodoCategory.self)
            }
        } catch {
            print("카테고리 불러오기오류: \(error)")
            throw TodoServiceError.firestoreError("Failed to fetch categories.")
        }
    }
    func addCategory(category: TodoCategory) -> TodoCategory?{
        let collectionRef = db.collection("categories")
        do {
            let newDocReference = try collectionRef.addDocument(from: category)
            
            var newCategory = category
            newCategory.id = newDocReference.documentID
            newCategory.createdAt = Timestamp(date: Date())
            print("카테고리 추가완료")
            return newCategory
        }
        catch {
            print("카테고리 추가중 에러뜸 \(error)")
            return nil
        }
    }
    func deleteCategory(category:TodoCategory, todoList: [Todo]) async throws {
        guard let categoryId = category.id else { return }
        let todoList =
        todoList.filter {$0.categoryId == categoryId} //지금 선택된 카테고리만 삭제하니깐 투두리스트 삭제다안됨
        
        do {
            try await db.collection("categories").document(categoryId).delete()
            
            for todo in todoList {
                try await deleteTodo(todo: todo) //카테고리 산하에 투두리스트도 다 삭제
            }
            print("카테고리삭제완료!")
        } catch {
            print("카테고리삭제오류: \(error)")
        }
        
    }
}
enum TodoServiceError: Error {
    case missingUserID
    case firestoreError(String)
}
