import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack{

            Image("loading")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
   
        }.background(Background())
        
    }
}

#Preview {
    LoadingView()
}
