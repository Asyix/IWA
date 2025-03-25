//
//  AddSellerView.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct CreateSellerView: View {
    @ObservedObject var sellerListViewModel: SellerListViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private func createSeller() async -> Bool {
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
        
        let createSellerDTO = CreateSellerDTO(
            name: name,
            email: email,
            phone: phone
        )
        do {
            try await sellerListViewModel.create(createSellerDTO: createSellerDTO)
            isLoading = false
            return true
        }
        catch let sellerError as RequestError {
            errorMessage = sellerError.message
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
                    Text("Enregistrer un vendeur")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
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
                        let success = await createSeller()
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
