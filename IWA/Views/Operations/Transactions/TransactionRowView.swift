//
//  TransactionRowView.swift
//  IWA
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct TransactionRowView: View {
    @ObservedObject var transaction: TransactionViewModel
    @State var photoURL: URL?
    
    init(transaction: TransactionViewModel) {
        self.transaction = transaction
        self._photoURL = State(initialValue: transaction.game.photoURL)
    }
    
    var body: some View {
        WhiteCard {
            HStack {
                // Photo du jeu
                if let gamePhotoURL = photoURL {
                    AsyncImage(url: gamePhotoURL) { image in
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
                    // Nom du jeu
                    Text(transaction.game.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    // Prix d'achat
                    Text("€\(transaction.depositedGame.salePrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                // Vendeur
                VStack {
                    Text("Vendeur:")
                        .font(.caption)
                    Text(transaction.seller.name)
                        .font(.subheadline)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Client
                VStack {
                    Text("Client:")
                        .font(.caption)
                    Text(transaction.client.name)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        }
        .onChange(of: transaction.game.photoURL) { newURL in
            self.photoURL = newURL
        }
        .padding(.vertical, 8)
    }
}
