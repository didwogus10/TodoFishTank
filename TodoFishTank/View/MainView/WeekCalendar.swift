import SwiftUI

struct WeekCalendar: View {
    @EnvironmentObject var todoViewModel: TodoViewModel
    
    let daysOfWeek: [Date]
    let today: Date
    
    init() {
        self.today = Calendar.current.startOfDay(for: Date()) // 오늘 날짜의 자정 기준
               let weekRange = DateHelper.weekRange(for: today)
               
               // 이번 주의 날짜들을 배열로 생성
               self.daysOfWeek = (0..<7).compactMap { dayOffset in
                   Calendar.current.date(byAdding: .day, value: dayOffset, to: weekRange.startOfWeek)
               }
    }
    
    // 날짜별 완료율 계산 --> todoViewModel도 있지만 그건 하루용
       private var completionRates: [Date: Int] {
           daysOfWeek.reduce(into: [:]) { rates, date in
               let todosForDate = todoViewModel.todoList.filter {
                   DateHelper.isSelectedDay($0.createdAt, selectedDay: date)
               }
               let total = todosForDate.count
               let completed = todosForDate.filter { $0.isComplete }.count
               rates[date] = total == 0 ? 0 : (completed * 100) / total
           }
       }
    
    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { date in
                VStack(spacing:5) {
                    Text(weekdayString(from: date))
                        .font(.system(size: 11))
                        .foregroundColor(
                            date == today ? .white : .gray)
                    
                    
                    Text(dayString(from: date))
                        .font(.system(size: 11))
                        .foregroundColor(
                            date == today ? .white : .black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            completionRates[date] == 100 ?
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color(hex: "#FF8357").opacity(0.5)) : nil)
                    
                    //그날의 달성률 100퍼면 색칠
                    
                }
                .padding(5)
                .background(
                    date == todoViewModel.selectedDay ?
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(.black, lineWidth: 2) : nil
                )
                .background(date == today ? RoundedRectangle(cornerRadius: 100)
                    .fill(Color(hex: "#FF632C")) : nil)
                
               
                
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    todoViewModel.selectedDay = date
                }
            }
        }
        
    }
    
    // 요일을 문자열로 변환하는 함수 (ex: "Mon", "Tue")
    func weekdayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    // 날짜를 문자열로 변환하는 함수 (ex: "12", "13")
    func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
}

#Preview {
    WeekCalendar().environmentObject(TodoViewModel(todoService: TodoService()))
}
