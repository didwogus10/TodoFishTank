import SwiftUI

struct AddCategoryButton: View {

    var body: some View {
        
            NavigationLink(destination: AddCategoryView()) {
                Text("+")
                    .font(.system(size: 32))
                    .fontWeight(.light)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background( LinearGradient.categoryBadge)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        
    }
}

#Preview {
    NavigationStack{
        AddCategoryButton()
    }
}
