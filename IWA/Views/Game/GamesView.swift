import SwiftUI

struct GamesView: View {
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Affichage pour tester
                Text("Session sélectionnée : \(sessionViewModel.name)")
                    .font(.title3)
                    .padding(.top, 16)
                    .foregroundColor(.gray)
                
                Text("Catalogue des jeux 🎮")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink("Détails d'un jeu", destination: GameDetailView())
                    .padding()
                
                NavigationLink("Réglages des jeux", destination: GameSettingsView())
                    .padding()
            }
            .navigationTitle("Jeux")
            .withNavigationBar()
            .withSessionSelector()
        }
    }
}
