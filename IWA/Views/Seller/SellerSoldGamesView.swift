import SwiftUI

struct SellerSoldGamesView: View {
    var body: some View {
        VStack {
            Text("Jeux vendus")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SellerSoldGamesView_Previews: PreviewProvider {
    static var previews: some View {
        SellerSoldGamesView()
    }
}
