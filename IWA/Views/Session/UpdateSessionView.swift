//
//  UpdateSessionView.swift
//  IWA
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct UpdateSessionView: View {
    @ObservedObject var sessionViewModel : SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    init (sessionViewModel : SessionViewModel) {
        self.sessionViewModel = sessionViewModel
        
        self._name = State(initialValue: sessionViewModel.name)
        self._description = State(initialValue: sessionViewModel.description ?? "")
        self._location = State(initialValue: sessionViewModel.location)
        self._startDate = State(initialValue: sessionViewModel.startDate)
        self._endDate = State(initialValue: sessionViewModel.endDate)
        self._depositFee = State(initialValue: String(sessionViewModel.depositFee))
        self._depositFeeLimitBeforeDiscount = State(initialValue: String(sessionViewModel.depositFeeLimitBeforeDiscount))
        self._depositFeeDiscount = State(initialValue: String(sessionViewModel.depositFeeDiscount))
        self._saleComission = State(initialValue: String(sessionViewModel.saleComission))
    }
    
    @State private var name: String
    @State private var description: String
    @State private var location: String
    
    @State private var startDate: Date
    @State private var endDate: Date
    
    @State private var depositFee: String
    @State private var depositFeeLimitBeforeDiscount: String
    @State private var depositFeeDiscount: String
    @State private var saleComission: String
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private func updateSession() async {
            guard let depositFeeValue = Double(depositFee),
                  let depositFeeLimit = Double(depositFeeLimitBeforeDiscount),
                  let depositFeeDisc = Double(depositFeeDiscount),
                  let saleComm = Double(saleComission) else {
                errorMessage = "Veuillez entrer des valeurs numériques valides pour les frais."
                return
            }

            isLoading = true
            errorMessage = nil
            
            do {
                await sessionViewModel.update(name: name, location: location, description: description.isEmpty ? description : nil, startDate: startDate, endDate: endDate, depositFee: depositFeeValue, depositFeeLimitBeforeDiscount: depositFeeLimit, depositFeeDiscount: depositFeeDisc, saleComission: saleComm)  // Persist changes to the backend
            }
            
            isLoading = false
        }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                WhiteCard {
                    Text("Modifier la session")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 12) {
                        TextField("Titre de la session", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Description (optionnelle)", text: $description)
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
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.poppins(fontStyle: .caption, fontWeight: .medium, isItalic: false))
                        .padding()
                }
                
                Button(action: {
                    Task {
                        await updateSession()
                    }
                    dismiss()
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Modifier la session")
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

