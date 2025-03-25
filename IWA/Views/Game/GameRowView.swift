//
//  GameRowView.swift
//  IWA
//
//  Created by etud on 21/03/2025.
//

import SwiftUI

struct GameRowView: View {
    @ObservedObject var gameViewModel : GameViewModel
    @State var nbForSale: Int
    
    init(gameViewModel : GameViewModel) {
        self.gameViewModel = gameViewModel
        nbForSale = gameViewModel.nbForSale
    }
    
    var body: some View {
        WhiteCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    WhiteCard {
                        // Image du jeu
                        AsyncImage(url: gameViewModel.photoURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .cornerRadius(8)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.CPsecondary)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    VStack(spacing: 4) {
                        WhiteCardSecondary {
                                VStack(spacing: 2) {
                                    Text(gameViewModel.name)
                                        .font(.poppins(fontStyle: .title3, fontWeight: .semibold, isItalic: false))
                                        .foregroundColor(.CPsecondary)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    
                                    Text(gameViewModel.publisher)
                                        .font(.poppins(fontStyle: .subheadline, fontWeight: .regular, isItalic: false))
                                        .foregroundColor(.CPsecondary)
                                }
                                .frame(width: 150)
                                .fixedSize(horizontal: true, vertical: false)
                            }
                            .frame(width: 200) // Largeur fixée ici
                            .fixedSize(horizontal: true, vertical: false) // Assure un bon rendu
                        if gameViewModel.nbForSale == 0 {
                            Text("Ruputure")
                                .font(.poppins(fontStyle: .body, fontWeight: .regular, isItalic: false))
                                .foregroundColor(.red)
                        }
                        else {
                            Text("\(gameViewModel.nbForSale) en stock")
                                .font(.poppins(fontStyle: .body, fontWeight: .regular, isItalic: false))
                                .foregroundColor(.CPsecondary)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            nbForSale = gameViewModel.nbForSale
        }
        .onChange(of: gameViewModel.nbForSale) { newNb in
            nbForSale = newNb
        }
    }
    

}


