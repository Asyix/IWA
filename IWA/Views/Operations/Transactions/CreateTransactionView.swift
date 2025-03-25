//
//  CreateTransactionView.swift
//  IWA
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct GameSaleOption: Identifiable {
    var id: String
    var name: String
    var price: Double
    
}

struct CreateTransactionView: View {
    @StateObject var transactionListViewModel: TransactionListViewModel
    @EnvironmentObject var sellerListViewModel: SellerListViewModel
    @EnvironmentObject var clientListViewModel: ClientListViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedClientId: String = ""
    @State private var selectedSellerId: String = ""
    @State private var selectedGameId: String = ""
    @State private var gameOptions: [GameSaleOption] = []
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private func createClient() async -> Bool {
        if [selectedGameId, selectedClientId, selectedSellerId].contains(where: { $0.isEmpty }) {
            errorMessage = "Veuillez remplir tous les champs."
            return false
        }

        isLoading = true
        errorMessage = nil
        
        guard let currentSession = sessionViewModel.currentSession else {
            errorMessage = "Pas de session en cours, impossible d'ajouter une vente."
            return false
        }
        let createTransactionDTO = CreateTransactionDTO(labelId: selectedGameId, sessionId: currentSession.id, sellerId: selectedSellerId, clientId: selectedClientId, transactionDate: Date())
        do {
            try await transactionListViewModel.create(createTransactionDTO: createTransactionDTO, sessionId: currentSession.id)
            isLoading = false
            return true
        }
        catch let transactionError as RequestError {
            errorMessage = transactionError.message
            isLoading = false
            return false
        }
        catch {
            errorMessage = "Une erreur s'est produite"
            isLoading = false
            return false
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                WhiteCard {
                    Text("Enregistrer une vente")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 12) {
                        Picker("Vendeur", selection: $selectedSellerId) {
                            if selectedSellerId.isEmpty {
                                Text("Aucun vendeur").tag("")
                            }
                            else {
                                ForEach(sellerListViewModel.sellerList) { seller in
                                    Text("\(seller.name) \(seller.email)").tag(seller.id)
                                }
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Jeu vendu", selection: $selectedGameId) {
                            if gameOptions.isEmpty {
                                Text("Aucun jeu disponible").tag("")
                            } else {
                                ForEach(gameOptions) { gameOption in
                                    let name = gameOption.name
                                    let price = String(format: "%.2f€", gameOption.price)
                                    Text("\(name) – \(price)").tag(gameOption.id)
                                }
                            }
                        }
                        .pickerStyle(.menu)
                        .disabled(gameOptions.isEmpty || selectedSellerId.isEmpty)
                        
                        Picker("Client", selection: $selectedClientId) {
                            if selectedClientId.isEmpty {
                                Text("Aucun client").tag("")
                            }
                            else {
                                ForEach(clientListViewModel.clientList) { client in
                                    Text("\(client.name) \(client.email)").tag(client.id)
                                }
                            }
                        }
                        .pickerStyle(.menu)
                        
                    }
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.poppins(fontStyle: .caption, fontWeight: .medium, isItalic: false))
                        .padding()
                }
                
                Button(action: {
                    Task {
                        let success = await createClient()
                        if success { dismiss() }
                    }
                    
                    
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Enregistrer")
                            .font(.poppins(fontStyle: .title3, fontWeight: .bold, isItalic: false))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(isLoading)
            }
            .padding()
        }
        .onAppear {
            Task {
                self.selectedClientId = clientListViewModel.clientList.first?.id ?? ""
                self.selectedSellerId = sellerListViewModel.sellerList.first?.id ?? ""
                self.gameOptions = updateSaleOptions(sellerId: self.selectedSellerId) ?? []
                self.selectedGameId = self.gameOptions.first?.id ?? ""
            }
            
        }
        .onChange(of: selectedSellerId) { newId in
            gameOptions = updateSaleOptions(sellerId: newId) ?? []
            selectedGameId = gameOptions.first?.id ?? ""
        }
        .withNavigationBar()
    }
    
    func updateSaleOptions(sellerId: String) -> [GameSaleOption]? {
        if let selectedSeller = sellerListViewModel.sellerList.first(where: { $0.id == sellerId }) {
            let sellerDepositedGames = selectedSeller.depositedGames
            // Only games currently for sale
            let gamesForSale = sellerDepositedGames.filter { $0.depositedGame.forSale }

            // Group by game name and sale price, then pick the first entry for each group
            let uniqueGames = Dictionary(grouping: gamesForSale) { gameForSale in
                "\(gameForSale.game.name)_\(gameForSale.depositedGame.salePrice)"
            }
            .compactMap { $0.value.first }

            // Map them to GameSaleOption instances
            let saleOptions: [GameSaleOption] = uniqueGames.map { gameEntry in
                GameSaleOption(
                    id: gameEntry.depositedGame.id,
                    name: gameEntry.game.name,
                    price: gameEntry.depositedGame.salePrice
                )
            }
            if !saleOptions.isEmpty {
                return saleOptions
            }
        }
        // Seller not found
        return nil
    }

}

