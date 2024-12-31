import Foundation
import FirebaseCore

struct DateHelper {
    static func weekRange(for date: Date = Date()) -> (startOfWeek: Date, endOfWeek: Date) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        // 이번 주의 시작일 (일요일)
        let daysFromSunday = weekday - calendar.firstWeekday
        let startOfWeek = calendar.date(byAdding: .day, value: -daysFromSunday, to: date)!
        let startOfWeekMidnight = calendar.startOfDay(for: startOfWeek)
        
        // 이번 주의 종료일 계산 (토요일 23:59:59 기준)
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeekMidnight)!
        let endOfWeekLastMoment = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endOfWeek)!
        
        return (startOfWeekMidnight, endOfWeekLastMoment)
    }
    // selectedDay와 createdAt을 비교하는 함수 추가
    static func isSelectedDay(_ timestamp: Timestamp?, selectedDay: Date?) -> Bool {
        guard let timestamp = timestamp, let selectedDay = selectedDay else { return false }
        let calendar = Calendar.current
        
        // 선택한 날짜의 자정 기준
        let startOfSelectedDay = calendar.startOfDay(for: selectedDay)
        
        // Todo의 생성 날짜의 자정 기준
        let startOfTodoDate = calendar.startOfDay(for: timestamp.dateValue())
        
        return startOfSelectedDay == startOfTodoDate // selectedDay와 비교
    }
    // selectedDay가 오늘인지 확인하는 함수
    static func isToday(_ selectedDay: Date?) -> Bool {
        guard let selectedDay = selectedDay else { return false }
        let calendar = Calendar.current
        
        // selectedDay와 오늘의 자정 기준을 비교
        return calendar.isDateInToday(selectedDay)
    }
}
