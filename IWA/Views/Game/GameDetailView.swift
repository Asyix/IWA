import SwiftUI

struct GameDetailView: View {
    var body: some View {
        VStack {
            Text("Détails du jeu 🎯")
                .font(.title)
                .padding()
        }
        .navigationTitle("Détail du jeu")
        .withNavigationBar()
    }
}
