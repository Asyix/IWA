import SwiftUI

struct GameListView: View {
    @StateObject var gameListViewModel: GameListViewModel
    @EnvironmentObject private var sessionViewModel : SessionViewModel
    @State var lastSessionId : String = "x"
    
    var body: some View {
        ZStack {
            ScrollView {
               VStack(spacing: 8) {
                   ForEach(gameListViewModel.gameList) { game in
                       NavigationLink(destination: GameView(gameViewModel: game)) {
                           GameRowView(gameViewModel: game)
                               .frame(maxWidth: .infinity)
                               .padding(10)
                       }
                   }
                   
               }
               .padding(.top)
               
            
            }
            // Bouton superposé (Z index : 1)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton(destination: CreateGameView(gameListViewmodel: gameListViewModel))
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Jeux")
        .onAppear {
            lastSessionId = sessionViewModel.id
            Task {
                try await gameListViewModel.loadGames()
                try await gameListViewModel.loadDepositedGames(sessionId: sessionViewModel.id)
            }
        }
        .onChange(of: sessionViewModel.id) { newId in
            Task {
                //try await gameListViewModel.loadGames()
                try await gameListViewModel.loadDepositedGames(sessionId: newId)
            }
        }

    }
}
/*
struct GameList_Previews: PreviewProvider {
    //@StateObject var gameListViewModel : GameListViewModel = GameListViewModel()
    static var previews: some View {
        GameListView(gameListViewModel: GameListViewModel())
    }
}
*/
