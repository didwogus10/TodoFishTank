import SwiftUI

struct AddCategoryButton: View {
    
    var body: some View {
        NavigationLink(destination: AddCategoryView()) {
            ZStack() {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient.categoryBadge)
                    .frame(width: 38, height: 38)
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.white)     
            }
        }
    }
}

#Preview {
    NavigationStack{
        AddCategoryButton()
    }
}
