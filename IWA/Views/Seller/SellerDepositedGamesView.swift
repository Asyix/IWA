import SwiftUI

struct SellerDepositedGamesView: View {
    var body: some View {
        VStack {
            Text("Jeux déposés")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SellerDepositedGamesView_Previews: PreviewProvider {
    static var previews: some View {
        SellerDepositedGamesView()
    }
}
