import Foundation
import FirebaseFirestore

struct Todo: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var isComplete: Bool
    var userId: String?
    var categoryId: String?
    @ServerTimestamp var createdAt: Timestamp?
}

struct TodoCategory: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var userId: String?
    @ServerTimestamp var createdAt: Timestamp?
}

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todoList : [Todo] = []
    @Published var categories : [TodoCategory] = []
    @Published var selectedCategory : String?
    @Published var isEditMode : Bool = false
    @Published var selectedDay : Date = Date()
    @Published var selectedTodo : Todo?
    @Published var errorMessage: String?
    
    
    // 계산된 프로퍼티로 완료율 계산
    var completionRate: Int {
        let todayTodoList = todoList.filter {
            DateHelper.isSelectedDay($0.createdAt, selectedDay: selectedDay)
        }
        let total = todayTodoList.count
        let completedTodo = todayTodoList.filter { $0.isComplete }.count
        
        return total == 0 ? 0 : (completedTodo * 100) / total
    }
    let todoService: TodoService
    
    init(todoService: TodoService) {
        self.todoService = todoService
    }
    //투두리스트 --------------------------------------------------
    //투두리스트 가져오기 --> 이번주꺼만 들고옴
    func fetchTodoList() async throws {
        todoList = try await todoService.fetchTodoList()
    }
    
    //투두 추가
    func addTodo(todo: Todo) {
        guard let newTodo = todoService.addTodo(todo: todo) else {
            return
        }
        todoList.append(newTodo)
    }
    
    //투두 삭제
    func deleteTodo(todo:Todo) async throws {
        try await todoService.deleteTodo(todo: todo)
        if let index = todoList.firstIndex(where: { $0.id == todo.id }) {
            todoList.remove(at: index)
        }
    }
    //투두 업뎃
    func updateTodo(todo:Todo) async throws {
        try await todoService.updateTodo(todo: todo)
        if let index = todoList.firstIndex(where: { $0.id == todo.id }) {
            todoList[index] = todo
        }
    }
    //토글업데이트
    func modifyTodoDone(todo: Todo) async throws {
        try await todoService.modifyTodoDone(todo: todo)
        if let index = todoList.firstIndex(where: { $0.id == todo.id }) {
            todoList[index].isComplete.toggle()
        }
    }
    //---------------------------카테고리------------------------
    //카테고리 가져오기
    func fetchCategories() async throws{
        categories = try await todoService.fetchCategories()
        selectCategory()
    }
    //카테고리 추가
    func addCategory(category: TodoCategory) {
        guard let newCategory = todoService.addCategory(category: category) else {
            return
        }
        categories.append(newCategory)
        selectCategory()
    }
    //카테고리 삭제
    func deleteCategory(category:TodoCategory) async throws {
        try await todoService.deleteCategory(category: category, todoList: todoList)
        todoList.removeAll { $0.categoryId == category.id }
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories.remove(at: index)
        }
        selectCategory()
    }
    //카테고리 자동 선택 로직
    func selectCategory() {
        //카테고리가 없는경우
        if categories.isEmpty {
            selectedCategory = nil
        //선택된 카테고리 없거나 선택된 카테고리가 삭제된 카테고리면 첫번째카테고리 선택
        } else if selectedCategory == nil || !categories.contains(where: { $0.id == selectedCategory }) {
            selectedCategory = categories.first?.id
        }
    }
}
