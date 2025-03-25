import SwiftUI


// Afficher ici les jeux achetés par le client
struct ClientBoughtGamesView: View {
    var body: some View {
        VStack {
            Text("Jeux achetés")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ClientBoughtGamesView_Previews: PreviewProvider {
    static var previews: some View {
        ClientBoughtGamesView()
    }
}
