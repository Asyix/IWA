//
//  CreatePaymentView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct CreatePaymentView: View {
    @ObservedObject var paymentListViewModel: PaymentListViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var sellerId: String = ""
    @State var depositFeePayed: String = ""
    
    init(paymentListViewModel : PaymentListViewModel) {
        self.paymentListViewModel = paymentListViewModel
        self._sellerId = State(initialValue: paymentListViewModel.sellerList.first?.id ?? "")
    }
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private func createPayment() async -> Bool {
        if [sellerId, depositFeePayed].contains(where: { $0.isEmpty }) {
            errorMessage = "Veuillez remplir tous les champs."
            return false
        }
        guard let depositFeePayed = Double(self.depositFeePayed) else {
            errorMessage = "Veuillez rentrer un numéro de téléphone à 10 chiffres."
            return false
        }

        isLoading = true
        errorMessage = nil

        let createPaymentDTO = CreatePaymentDTO(sellerId: sellerId, sessionId: sessionViewModel.id, depositFeePayed: depositFeePayed, depositDate: JSONHelper.dateFormatter.string(from: Date()))
        do {
            try await paymentListViewModel.create(createPaymentDTO: createPaymentDTO)
            isLoading = false
        }
        catch let paymentError as RequestError {
            errorMessage = paymentError.message
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
                    Text("Ajouter un paiement")
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
                                    ForEach(paymentListViewModel.sellerList) { seller in
                                        Text("\(seller.name) \(seller.email)").tag(seller.id)
                                    }
                                }
                            }
                            .pickerStyle(.menu)
                            
                            TextField("Montant", text: $depositFeePayed)
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
                        let success = await createPayment()
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

