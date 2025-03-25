//
//  CreateManagerView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct CreateManagerView: View {
    @ObservedObject var managerListViewModel: ManagerListViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var email: String = ""
    @State var password = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var phone: String = ""
    @State var address: String = ""
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private func createManager() async -> Bool {
        if [email, firstName, lastName, phone, address, password].contains(where: { $0.isEmpty }) {
            errorMessage = "Veuillez remplir tous les champs."
            return false
        }
        if phone.count < 10 {
            errorMessage = "Veuillez rentrer un numéro de téléphone à 10 chiffres."
            return false
        }
        if password.count < 8 {
            errorMessage = "Veuillez entrer un mot de passe d'au moins 8 caractères."
            return false
        }

        isLoading = true
        errorMessage = nil

        let createManagerDTO = CreateManagerDTO(firstName: firstName, lastName: lastName, email: email, phone: phone, address: address, password: password)
        do {
            try await managerListViewModel.create(createManagerDTO: createManagerDTO)
            isLoading = false
        }
        catch let managerError as RequestError {
            errorMessage = managerError.message
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
                    Text("Ajouter un manager")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 12) {
                        
                        TextField("Nom", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Prénom", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Adresse Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Numéro de téléphone", text: $phone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        TextField("Adresse Postale", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Mot de passe", text: $password)
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

