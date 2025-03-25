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
                
                // Titre du jeu et prix
                VStack(alignment: .leading) {
                    Text(deposit.name)
                        .font(.poppins(fontStyle: .title3, fontWeight: .semibold, isItalic: false))
                        .foregroundColor(.CPsecondary)
                    
                    Text("Prix de vente : €\(deposit.salePrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .padding(.bottom, 8)
                }

                // Informations du vendeur avec icône
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.blue)
                    Text("Vendeur : \(deposit.seller.name)")
                        .font(.poppins(fontStyle: .body, fontWeight: .regular, isItalic: false))
                        .foregroundColor(.CPsecondary)
                }
                .padding(.bottom, 8)

                // Disponibilité et état
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(deposit.forSale ? .green : .red)
                        Text("Disponibilité : \(deposit.forSale ? "À la vente" : "Non disponible")")
                            .font(.subheadline)
                            .foregroundColor(deposit.forSale ? .green : .red)
                    }
                    
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(deposit.sold ? .green : .red)
                        Text("État : \(deposit.sold ? "Vendu" : "Non vendu")")
                            .font(.subheadline)
                            .foregroundColor(deposit.sold ? .green : .red)
                    }
                    
                    HStack {
                        Image(systemName: "folder.fill")
                            .foregroundColor(deposit.pickedUp ? .green : .red)
                        Text("Récupéré : \(deposit.pickedUp ? "Oui" : "Non")")
                            .font(.subheadline)
                            .foregroundColor(deposit.pickedUp ? .green : .red)
                    }
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .padding(.vertical, 8)
    }
}

