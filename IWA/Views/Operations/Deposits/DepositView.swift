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
                        VStack(alignment: .leading, spacing: 12) {
                            // Titre du jeu et photo
                            HStack {
                                Text("Titre du jeu :")
                                    .font(.headline)
                                Spacer()
                                Text(depositViewModel.name)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                            
                            // Image du jeu avec une icône par défaut
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
                            } else {
                                Image(systemName: "gamecontroller.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                            
                            // Prix de vente avec une icône
                            HStack {
                                Image(systemName: "eurosign.circle.fill")
                                    .foregroundColor(.green)
                                Text("Prix de vente : €\(depositViewModel.salePrice, specifier: "%.2f")")
                                    .font(.subheadline)
                            }
                            
                            // Vendeur avec une icône
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.blue)
                                Text("Vendeur : \(depositViewModel.seller.name)")
                                    .font(.subheadline)
                            }
                            
                            // Disponibilité et statut
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(depositViewModel.forSale ? .green : .red)
                                Text("État de vente : \(depositViewModel.forSale ? "À la vente" : "Non disponible")")
                                    .font(.subheadline)
                                    .foregroundColor(depositViewModel.forSale ? .green : .red)
                            }
                            
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(depositViewModel.sold ? .green : .red)
                                Text("Statut de vente : \(depositViewModel.sold ? "Vendu" : "Non vendu")")
                                    .font(.subheadline)
                                    .foregroundColor(depositViewModel.sold ? .green : .red)
                            }
                            
                            HStack {
                                Image(systemName: "folder.fill")
                                    .foregroundColor(depositViewModel.pickedUp ? .green : .red)
                                Text("Récupéré : \(depositViewModel.pickedUp ? "Oui" : "Non")")
                                    .font(.subheadline)
                                    .foregroundColor(depositViewModel.pickedUp ? .green : .red)
                            }
                        }
                        .padding()
                    }
                    
                    // Affichage du message d'erreur si nécessaire
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


