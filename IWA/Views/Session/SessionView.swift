//
//  SessionView.swift
//  IWA
//
//  Created by etud on 19/03/2025.
//

import SwiftUI

struct SessionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var sessionViewModel : SessionViewModel
    @State var showOptions : Bool = false
    
    private func toggleOptions() {
        if showOptions {
            withAnimation(.easeInOut(duration: 0.3)) {
                showOptions = false
            }
        }
        else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showOptions = true
            }
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                WhiteCard {
                    // Nom de la session
                    Text(sessionViewModel.name)
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top)
                
                WhiteCard{
                    VStack(alignment: .leading, spacing: 6) {
                       // Localisation
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.red)
                                .font(.system(size: 30))
                            Text(sessionViewModel.location)
                                .font(.poppins(fontStyle: .title3, fontWeight: .medium, isItalic: false))
                        }
                        
                        
                        // Dates de début et de fin
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                                .font(.system(size: 30))
                            VStack(alignment: .leading) {
                                Text("Début : \(formattedDate(sessionViewModel.startDate))")
                                    .font(.poppins(fontStyle: .title3, fontWeight: .light, isItalic: false))
                                Text("Fin : \(formattedDate(sessionViewModel.endDate))")
                                    .font(.poppins(fontStyle: .title3, fontWeight: .light, isItalic: false))
                            }
                        }
                        
                        VStack(alignment: .center, spacing: 16) {
                            FeeBlock(title: "Frais de dépôt", value: "\(sessionViewModel.depositFee)%")
                            FeeBlock(title: "Limite avant remise", value: "\(sessionViewModel.depositFeeLimitBeforeDiscount)€")
                            FeeBlock(title: "Commissions de vente", value: "\(sessionViewModel.saleComission)%")
                        }
                        .padding()
                    }
                }
                .padding(.top, 5)
                
                // Description
                if let description = sessionViewModel.description {
                    WhiteCard {
                        Text(description)
                            .font(.poppins(fontStyle: .title3, fontWeight: .light, isItalic: true))
                            .foregroundColor(.CPsecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.top, 5)
                }
            }
            VStack {
                Spacer()
                HStack(spacing: 15) {
                    Spacer()
                    VStack(alignment: .trailing) {
                        HStack(spacing: 10) {
                            if showOptions {
                                AddButton(destination: CreateSessionView(sessionViewModel: sessionViewModel))
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                                UpdateButton(destination: UpdateSessionView(sessionViewModel: sessionViewModel))
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                                DeleteButton(title: "Etes vous sur de vouloir supprimer \(sessionViewModel.name) ?") {
                                    Task {
                                        await deleteSession()
                                    }
                                    dismiss()
                                }
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                    }
                    OptionsButton(action: toggleOptions)
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("\(sessionViewModel.name)")
        .withNavigationBar()
        .withSessionSelector(sessionViewModel: sessionViewModel, isOnSessionView: true)
        
    }
    
    // Formatteur de date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func deleteSession() async {
        do {
            await sessionViewModel.delete()
        }
    }
}
