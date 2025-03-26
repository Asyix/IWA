//
//  UpdateDepositView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct UpdateDepositView: View {
    @ObservedObject var depositViewModel: DepositViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var salePrice: String
    @State var forSale: Bool
    @State var pickedUp: Bool
    
    init(depositViewModel: DepositViewModel) {
        self.depositViewModel = depositViewModel
        self._forSale = State(initialValue: depositViewModel.forSale)
        self._pickedUp = State(initialValue: depositViewModel.pickedUp)
        self._salePrice = State(initialValue: String(depositViewModel.salePrice))
    }
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private func updateDeposit() async -> Bool {
        if [salePrice].contains(where: { $0.isEmpty }) {
            errorMessage = "Veuillez remplir tous les champs."
            return false
        }
        
        guard let salePrice = Double(self.salePrice) else {
            errorMessage = "Veuillez renseigner une valeur numérique correcte pour le prix de vente."
            return false
        }

        isLoading = true
        errorMessage = nil
        
        let updateDepositDTO = DepositedGameDTO(_id: depositViewModel.id, salePrice: salePrice, sold: false, forSale: forSale, pickedUp: pickedUp, sessionId: sessionViewModel.id, sellerId: depositViewModel.sellerId, gameDescriptionId: depositViewModel.gameId)
        do {
            try await depositViewModel.updateDepositedGame(depositedGameDTO: updateDepositDTO)
            isLoading = false
            return true
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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                WhiteCard {
                    Text("Déposer un jeu")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    Text("Jeu :\(depositViewModel.name)")
                        .textFieldStyle(.roundedBorder)
                        
                        
                    Text("Vendeur : \(depositViewModel.seller.name) \(depositViewModel.seller.email)")
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Prix", text: $salePrice)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Toggle(isOn: $forSale) {
                        Text("Disponible à la vente")
                    }
                    .onChange(of: forSale) { newValue in
                        if newValue {
                            self.pickedUp = false // Turn off 'pickedUp' when 'forSale' is turned on
                        }
                    }
                    .disabled(depositViewModel.sold)

                    Toggle(isOn: $pickedUp) {
                        Text("Récupéré")
                    }
                    .onChange(of: pickedUp) { newValue in
                        if newValue {
                            self.forSale = false // Turn off 'forSale' when 'pickedUp' is turned on
                        }
                    }
                    .disabled(depositViewModel.sold)

                    Toggle(isOn: $depositViewModel.sold) {
                        Text("Vendu")
                    }
                    .disabled(true)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.poppins(fontStyle: .caption, fontWeight: .medium, isItalic: false))
                        .padding()
                }
                
                Button(action: {
                    Task {
                        let success = await updateDeposit()
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


