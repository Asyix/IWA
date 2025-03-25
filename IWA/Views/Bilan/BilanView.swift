import SwiftUI

struct BilanView: View {
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @State var nbSales: Int = 0
    @State var nbDeposits: Int = 0
    @State var amountSold: Double = 0
    @State var depositFees: Double = 0
    @State var saleFees: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Titre du bilan
                Text("BILAN FINANCIER")
                    .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                    .foregroundColor(.primary)
                    .padding(.top, 20)
                
                // Affichage des informations principales dans des cartes
                BluePurpleCard {
                    VStack(alignment: .leading) {
                        FeeBlock(title: "Nombre de ventes", value: "\(nbSales)")
                        FeeBlock(title: "Nombre de dépôts", value: "\(nbDeposits)")
                    }
                }
                
                // Affichage des frais
                WhiteCard {
                    FeeBlock(title: "Montant total vendu", value: "\(amountSold) €")
                    FeeBlock(title: "Frais de dépôt", value: "\(depositFees.rounded()) €")
                    FeeBlock(title: "Frais de vente", value: "\(saleFees.rounded()) €")
                }
                
            }
            .padding()
        }
        .onAppear {
            Task {
                try await loadBilanInfos(sessionId: sessionViewModel.id)
            }
        }
        .onChange(of: sessionViewModel.id) { newId in
            Task {
                try await loadBilanInfos(sessionId: newId)
            }
        }
        .navigationBarTitle("Bilan", displayMode: .inline)
    }
    
    func loadBilanInfos(sessionId: String) async throws {
        do {
            let fetchedDepositedGames = try await DepositedGameService.getAllDepositedGames(sessionId: sessionId)
            let fetchedTransactions = try await TransactionService.getAllTransactions(sessionId: sessionId)
            DispatchQueue.main.async {
                // Remise à zéro des compteurs
                self.saleFees = 0
                self.depositFees = 0
                self.nbDeposits = 0
                self.nbSales = 0
                
                self.nbSales = fetchedTransactions.count
                self.nbDeposits = fetchedDepositedGames.count
                // pour chaque jeu déposé
                for depositedGame in fetchedDepositedGames {
                    self.depositFees += depositedGame.salePrice * (sessionViewModel.depositFee / 100)
                        // si le jeu a été vendu
                        if depositedGame.sold {
                            self.amountSold += depositedGame.salePrice
                        }
                    }
                self.saleFees = self.depositFees * (sessionViewModel.saleComission / 100)
            }
        }
        catch let requestError as RequestError {
            throw RequestError.networkError(requestError)
        }
    }
}
