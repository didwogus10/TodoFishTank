
import SwiftUI

struct ItemImage: View {
    @State private var draggedOffset = CGSize.zero
    @Binding var accumulatedOffset: CGSize
    @Binding var magnifyBy: CGFloat
    var path: String
    
    var magnification: some Gesture {
        MagnifyGesture(minimumScaleDelta: magnifyBy)
            .onChanged { value in
                magnifyBy = value.magnification
            }
    }
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                let maxOffset = CGSize(
                    width: (UIScreen.main.bounds.width / 2) - 20,  // 이미지 크기 고려
                    height: (UIScreen.main.bounds.height / 6) - 20
                )
                let minOffset = CGSize(
                    width: -(UIScreen.main.bounds.width / 2) + 20,
                    height: -(UIScreen.main.bounds.height / 6) + 20
                )
                // 임시 드래그 오프셋
                let tentativeOffset = CGSize(
                    width: accumulatedOffset.width + value.translation.width,
                    height: accumulatedOffset.height + value.translation.height
                )
                
                // 최대/최소 값을 넘어가지 않도록 제한
                draggedOffset = CGSize(
                    width: max(min(tentativeOffset.width, maxOffset.width), minOffset.width) - accumulatedOffset.width,
                    height: max(min(tentativeOffset.height, maxOffset.height), minOffset.height) - accumulatedOffset.height
                )
            }
            .onEnded { value in
                accumulatedOffset.width += draggedOffset.width
                accumulatedOffset.height += draggedOffset.height
                draggedOffset = .zero
                
            }
    }
    
    var body: some View {
        VStack {
            Image(path)
                .resizable()
                .aspectRatio(contentMode: .fit) //크기가 커져도 비율 유지
                .frame(width: UIScreen.main.bounds.width / 4) //화면에 나타낼 샵아이템크기
//                .scaleEffect(magnifyBy)
//                .gesture(magnification)
                .offset(x: draggedOffset.width + accumulatedOffset.width,
                        y: draggedOffset.height + accumulatedOffset.height)
            
                .simultaneousGesture(drag)
            
        }
        
        
    }
    
    
}


#Preview {
    @Previewable @State  var accumulatedOffset = CGSize.zero
    @Previewable @State  var magnifyBy: CGFloat = 1.0
    
    return ItemImage(
        accumulatedOffset: $accumulatedOffset,
        magnifyBy: $magnifyBy,
        path: "shop/seaWeeds/1"
        
    )
}
