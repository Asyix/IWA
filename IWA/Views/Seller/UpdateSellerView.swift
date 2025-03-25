//
//  UpdateSellerView.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct UpdateSellerView: View {
    @ObservedObject var sellerViewModel: SellerViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    init(sellerViewModel: SellerViewModel) {
        self.sellerViewModel = sellerViewModel
        
        self._name = State(initialValue: sellerViewModel.name)
        self._email = State(initialValue: sellerViewModel.email)
        self._phone = State(initialValue: sellerViewModel.phone)
    }
    
    private func updateSeller() async -> Bool {
        if [name, email, phone].contains(where: { $0.isEmpty }) {
            errorMessage = "Veuillez remplir tous les champs."
            return false
        }
        if phone.count < 10 {
            errorMessage = "Veuillez rentrer un numéro de téléphone à 10 chiffres."
            return false
        }

        isLoading = true
        errorMessage = nil
        
        let updateSellerDTO = SellerDTO(
            _id : sellerViewModel.id,
            name: name,
            email: email,
            phone: phone,
            amountOwed: sellerViewModel.amountOwed
        )
        do {
            try await sellerViewModel.updateSeller(sellerDTO: updateSellerDTO)
            isLoading = false
            return true

            
        }
        catch let sellerError as RequestError {
            errorMessage = sellerError.message
            isLoading = false
            return false
        }
        catch {
            errorMessage = "Une erreur s'est produite."
            isLoading = false
            return false
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                WhiteCard {
                    Text("Modifier un vendeur")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 12) {
                        TextField("Nom du vendeur", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Adresse Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Numéro de téléphone", text: $phone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                        let success = await updateSeller()
                        if success { dismiss() }
                    }
                    
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Modifier le vendeur")
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

