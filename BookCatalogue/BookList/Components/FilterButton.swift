//

import SwiftUI

struct FilterButton: View {
    let title: String
    var onClick: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            
            Button(action: onClick) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(width: 100, height: 40)
                    .background(Color("buttonBackground"))
                    .foregroundColor(Color("ButtonForeground"))
                    .cornerRadius(10)
            }
        }
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton(
            title: "Title",
            onClick: { }
        )
    }
}
