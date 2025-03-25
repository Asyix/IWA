//
//  DepositRowView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct DepositRowView: View {
    @ObservedObject var deposit: DepositViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @State private var isNavigatingToUpdate = false
    
    var body: some View {
        WhiteCard {
            HStack {
                // Image du jeu
                if let photoURL = deposit.photoURL {
                    AsyncImage(url: photoURL) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 50, height: 50)
                    }
                } else {
                    Image(systemName: "gamecontroller.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading) {
                    // Titre du jeu
                    Text(deposit.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    // Prix de vente
                    Text("€\(deposit.salePrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    
                    // Vendeur
                    Text("Vendeur : \(deposit.seller.name)")
                        .font(.caption)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack {
                    Text("Disponibilité :")
                        .font(.caption)
                    Text(deposit.forSale ? "À la vente" : "Non disponible")
                        .font(.subheadline)
                        .foregroundColor(deposit.forSale ? .green : .red)
                }
                
                VStack {
                    Text("État :")
                        .font(.caption)
                    Text(deposit.sold ? "Vendu" : "Non vendu")
                        .font(.subheadline)
                        .foregroundColor(deposit.sold ? .green : .red)
                }
                
                VStack {
                    Text("Récupéré :")
                        .font(.caption)
                    Text(deposit.pickedUp ? "Oui" : "Non")
                        .font(.subheadline)
                        .foregroundColor(deposit.pickedUp ? .green : .red)
                }
                
                // Bouton modifier
                NavigationLink(destination: UpdateDepositView(depositViewModel: deposit)) {
                    Text("Modifier")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(5)
                        .background(Capsule().strokeBorder(Color.blue))
                }
            }
            .padding()
        }
        .padding(.vertical, 8)
    }
}

