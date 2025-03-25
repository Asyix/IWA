//
//  DepositView.swift
//  IWA
//
//  Created by etud on 24/03/2025.
//

import SwiftUI


struct DepositView: View {
    @StateObject var depositViewModel: DepositViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    WhiteCard {
                        VStack(alignment: .leading) {
                            Text("Titre du jeu : \(depositViewModel.name)")
                                .font(.headline)
                            
                            if let photoURL = depositViewModel.photoURL {
                                AsyncImage(url: photoURL) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 100, height: 100)
                                }
                            }
                            
                            Text("Prix de vente : €\(depositViewModel.salePrice, specifier: "%.2f")")
                                .font(.subheadline)
                            
                            Text("Vendeur : \(depositViewModel.seller.name)")
                                .font(.subheadline)
                            
                            Text("État de vente : \(depositViewModel.forSale ? "À la vente" : "Non disponible")")
                                .font(.subheadline)
                            
                            Text("Statut de vente : \(depositViewModel.sold ? "Vendu" : "Non vendu")")
                                .font(.subheadline)
                            
                            Text("Récupéré : \(depositViewModel.pickedUp ? "Oui" : "Non")")
                                .font(.subheadline)
                        }
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.poppins(fontStyle: .caption, fontWeight: .medium, isItalic: false))
                            .padding()
                    }
                    
                    // Bouton pour rediriger vers la page de modification
                    NavigationLink(destination: UpdateDepositView(depositViewModel: depositViewModel)
                                    .environmentObject(sessionViewModel)) {
                        Text("Modifier")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    UpdateButton(destination: UpdateDepositView(depositViewModel: depositViewModel).environmentObject(sessionViewModel))
                }
                .padding()
            }
        }
        .navigationTitle("Détail dépôt")
        .withNavigationBar()
    }
}


