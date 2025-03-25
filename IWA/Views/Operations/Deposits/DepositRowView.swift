//
//  DepositRowView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct DepositRowView: View {
    @ObservedObject var deposit: DepositViewModel
    
    var body: some View {
        WhiteCard {
            VStack(alignment: .leading) {
                // Image du jeu
                HStack {
                    Spacer()
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
                    Spacer()
                }
                
                
                VStack(alignment: .leading) {
                    // Titre du jeu
                    Text(deposit.name)
                        .font(.poppins(fontStyle: .title3, fontWeight: .semibold, isItalic: false))
                        .foregroundColor(.CPsecondary)
                    
                    // Prix de vente
                    Text("Prix de vente : €\(deposit.salePrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    
                    // Vendeur
                    Text("Vendeur : \(deposit.seller.name)")
                        .font(.poppins(fontStyle: .body, fontWeight: .regular, isItalic: false))
                        .foregroundColor(.CPsecondary)
                }
                
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Text("Disponibilité :")
                            .font(.poppins(fontStyle: .body, fontWeight: .regular, isItalic: false))
                            .foregroundColor(.CPsecondary)
                        Text(deposit.forSale ? "À la vente" : "Non disponible")
                            .font(.subheadline)
                            .foregroundColor(deposit.forSale ? .green : .red)
                    }
                    
                    HStack {
                        Text("État :")
                            .font(.poppins(fontStyle: .body, fontWeight: .regular, isItalic: false))
                            .foregroundColor(.CPsecondary)
                        Text(deposit.sold ? "Vendu" : "Non vendu")
                            .font(.subheadline)
                            .foregroundColor(deposit.sold ? .green : .red)
                    }
                    
                    HStack {
                        Text("Récupéré :")
                            .font(.poppins(fontStyle: .body, fontWeight: .regular, isItalic: false))
                            .foregroundColor(.CPsecondary)
                        Text(deposit.pickedUp ? "Oui" : "Non")
                            .font(.subheadline)
                            .foregroundColor(deposit.pickedUp ? .green : .red)
                    }
                }
                
            }
            .padding()
        }
        .padding(.vertical, 8)
    }
}

