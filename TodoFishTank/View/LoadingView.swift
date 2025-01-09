import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(hex: "#B9FFF6").ignoresSafeArea()
            VStack{
                Image("loading")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 160)
            }
        }
    }
}

#Preview {
    LoadingView()
}
