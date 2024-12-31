import SwiftUI

extension LinearGradient {
    
    // 단색처럼 보이는 그라데이션
    static func solidColor(_ color: Color) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [color, color]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    // 카테고리 뱃지 색상
    static var categoryBadge =
    LinearGradient(
        gradient: Gradient(colors: [Color(hex: "#FF6833"), Color(hex: "#FF255E")]), // 커스텀 색상
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // 할일 체크 박스 색상
    static var taskCheck =
    LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.07, green: 0.94, blue: 0.67), location: 0.00),
            Gradient.Stop(color: Color(red: 0.05, green: 0.72, blue: 0.95), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0.5, y: 0),
        endPoint: UnitPoint(x: 0.5, y: 1)
    )
    //알람 확인 버튼 색상
    static var alertAccept =
    LinearGradient(
    stops: [
    Gradient.Stop(color: Color(red: 1, green: 0.41, blue: 0.2), location: 0.00),
    Gradient.Stop(color: Color(red: 0.95, green: 0.25, blue: 0), location: 1.00),
    ],
    startPoint: UnitPoint(x: 0.49, y: 0.1),
    endPoint: UnitPoint(x: 0.5, y: 0.87)
    )
    
}
