//
//  UpdateClientView.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct UpdateClientView: View {
    @ObservedObject var clientViewModel: ClientViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    @State private var phone = ""
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    init(clientViewModel: ClientViewModel) {
        self.clientViewModel = clientViewModel
        
        self._name = State(initialValue: clientViewModel.name)
        self._email = State(initialValue: clientViewModel.email)
        self._address = State(initialValue: clientViewModel.address)
        self._phone = State(initialValue: clientViewModel.phone)
    }
    
    private func updateClient() async -> Bool {
        if [name, email, address, phone].contains(where: { $0.isEmpty }) {
            errorMessage = "Veuillez remplir tous les champs."
            return false
        }
        if phone.count < 10 {
            errorMessage = "Veuillez rentrer un numéro de téléphone à 10 chiffres."
            return false
        }

        isLoading = true
        errorMessage = nil
        
        let updateClientDTO = ClientDTO(_id: clientViewModel.id ,name: name, email: email, phone: phone, address: address)
        do {
            try await clientViewModel.updateClient(clientDTO: updateClientDTO)
            isLoading = false
            return true

            
        }
        catch let clientError as RequestError {
            errorMessage = clientError.message
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
                    Text("Modifier un client")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 12) {
                        TextField("Nom du vendeur", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Adresse Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Adresse postale", text: $address)
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
                        let success = await updateClient()
                        if success { dismiss() }
                    }
                    
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Modifier le client")
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

