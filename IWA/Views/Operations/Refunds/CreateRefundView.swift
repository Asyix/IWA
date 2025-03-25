//
//  CreateRefundView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct CreateRefundView: View {
    @ObservedObject var refundListViewModel: RefundListViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var sellerId: String = ""
    @State var refundAmount: String = ""
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private func createManager() async -> Bool {
        if [sellerId, refundAmount].contains(where: { $0.isEmpty }) {
            errorMessage = "Veuillez remplir tous les champs."
            return false
        }
        guard let refundAmount = Double(self.refundAmount) else {
            errorMessage = "Veuillez rentrer un numéro de téléphone à 10 chiffres."
            return false
        }

        isLoading = true
        errorMessage = nil

        let createRefundDTO = CreateRefundDTO(sellerId: sellerId, sessionId: sessionViewModel.id, refundAmount: refundAmount, depositDate: JSONHelper.dateFormatter.string(from: Date()))
        do {
            try await refundListViewModel.create(createRefundDTO: createRefundDTO)
            isLoading = false
        }
        catch let refundError as RequestError {
            errorMessage = refundError.message
            isLoading = false
            return false
        }
        catch {
            errorMessage = "Une erreur s'est produite"
            isLoading = false
            return false
        }
        return true
        
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                WhiteCard {
                    Text("Ajouter un remboursement")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 12) {
                        
                        VStack(spacing: 12) {
                            Picker("Vendeur", selection: $sellerId) {
                                if sellerId.isEmpty {
                                    Text("Aucun vendeur").tag("")
                                }
                                else {
                                    ForEach(refundListViewModel.sellerList) { seller in
                                        Text("\(seller.name) \(seller.email)").tag(seller.id)
                                    }
                                }
                            }
                            .pickerStyle(.menu)
                            
                            TextField("Montant", text: $refundAmount)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
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
                        let success = await createManager()
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

