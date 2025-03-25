//
//  CreateDepositView.swift
//  IWA
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct CreateDepositView: View {
    @ObservedObject var depositListViewModel: DepositListViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var salePrice: String = ""
    @State var forSale: Bool = false
    @State var selectedSellerId: String
    @State var selectedGameId: String
    @State var quantity: String = ""
    
    init(depositListViewModel: DepositListViewModel) {
        self.depositListViewModel = depositListViewModel
        self._selectedSellerId = State(initialValue: depositListViewModel.sellerList.first?.id ?? "")
        self._selectedGameId = State(initialValue: depositListViewModel.gameList.first?.id ?? "")
    }
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private func createDeposit() async -> Bool {
        if [salePrice, quantity].contains(where: { $0.isEmpty }) {
            errorMessage = "Veuillez remplir tous les champs."
            return false
        }
        
        guard let salePrice = Double(self.salePrice),
              let quantity = Int(self.quantity) else {
            errorMessage = "Veuillez renseigner des valeurs numériques correctes.."
            return false
        }

        isLoading = true
        errorMessage = nil
        for _ in 0..<quantity {
            let createDepositDTO = CreateDepositedGameDTO(salePrice: salePrice, sold: false, forSale: forSale, pickedUp: false, sessionId: sessionViewModel.id, sellerId: selectedSellerId, gameDescriptionId: selectedGameId)
            do {
                try await depositListViewModel.create(createDepositDTO: createDepositDTO)
                isLoading = false
            }
            catch let depositError as RequestError {
                errorMessage = depositError.message
                isLoading = false
                return false
            }
            catch {
                errorMessage = "Une erreur s'est produite"
                isLoading = false
                return false
            }
        }
        return true
        
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                WhiteCard {
                    Text("Déposer un jeu")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 12) {
                        Picker("Jeu à déposer", selection: $selectedGameId) {
                            if selectedGameId.isEmpty {
                                Text("Aucun jeu").tag("")
                            }
                            else {
                                ForEach(depositListViewModel.gameList) { game in
                                    Text("\(game.name)").tag(game.id)
                                }
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Vendeur", selection: $selectedSellerId) {
                            if selectedSellerId.isEmpty {
                                Text("Aucun vendeur").tag("")
                            }
                            else {
                                ForEach(depositListViewModel.sellerList) { seller in
                                    Text("\(seller.name) \(seller.email)").tag(seller.id)
                                }
                            }
                        }
                        .pickerStyle(.menu)
                        
                        TextField("Prix", text: $salePrice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Quantité", text: $quantity)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Toggle(isOn: $forSale) {
                            Text("Disponible à la vente")
                        }
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
                        let success = await createDeposit()
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
        .withNavigationBar()
    }
}

