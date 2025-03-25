//
//  CreateSessionView.swift
//  IWA
//
//  Created by etud on 20/03/2025.
//


import SwiftUI

struct CreateSessionView: View {
    @StateObject var sessionViewModel : SessionViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var depositFee: String = ""
    @State private var depositFeeLimitBeforeDiscount: String = ""
    @State private var depositFeeDiscount: String = ""
    @State private var saleComission: String = ""
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private func createSession() async -> Bool {
        if [name, location, depositFee, depositFeeLimitBeforeDiscount, depositFeeDiscount, saleComission].contains(where: { $0.isEmpty }) {
            errorMessage = "Veuillez remplir tous les champs."
            return false
        }
        guard let depositFeeLimit = Double(depositFeeLimitBeforeDiscount),
              let depositFeeDisc = Double(depositFeeDiscount),
              let saleComm = Double(saleComission),
              let depositFee = Double(depositFee) else {
            errorMessage = "Veuillez entrer des valeurs numériques valides pour les frais."
            return false
        }

        isLoading = true
        errorMessage = nil
        
        let createSessionDTO = CreateSessionDTO(
            name: name,
            location: location,
            description: description.isEmpty ? nil : description,
            startDate: JSONHelper.dateFormatter.string(from: startDate),
            endDate: JSONHelper.dateFormatter.string(from: endDate),
            depositFee: depositFee,
            depositFeeLimitBeforeDiscount: depositFeeLimit,
            depositFeeDiscount: depositFeeDisc,
            saleComission: saleComm
        )
        do {
            try await sessionViewModel.create(createSessionDto: createSessionDTO)
            isLoading = false
            return true
        }
        catch let sessionError as SessionError {
            errorMessage = sessionError.message
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
                    Text("Créer une nouvelle session")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 12) {
                        TextField("Titre de la session", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Localisation", text: $location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        DatePicker("Date de début", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                        
                        DatePicker("Date de fin", selection: $endDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                }
                
                WhiteCard {
                    VStack(spacing: 12) {
                        TextField("Frais de dépôt (%)", text: $depositFee)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        TextField("Limite avant remise (€)", text: $depositFeeLimitBeforeDiscount)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        TextField("Remise sur frais de dépôt (%)", text: $depositFeeDiscount)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        TextField("Commission de vente (%)", text: $saleComission)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                }
                
                WhiteCard {
                    Text("Description (optionnelle)")
                    TextEditor(text: $description)
                            .frame(minHeight: 100)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.poppins(fontStyle: .caption, fontWeight: .medium, isItalic: false))
                        .padding()
                }
                
                Button(action: {
                    Task {
                        let sucess = await createSession()
                        if sucess { dismiss() }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Créer la session")
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
