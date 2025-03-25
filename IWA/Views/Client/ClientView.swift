//
//  ClientView.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

enum ClientTab: String, CaseIterable {
    case bought = "Jeux achetés"
    case info = "Informations"
}

struct ClientView: View {
    @StateObject var clientViewModel: ClientViewModel
    @StateObject var clientListViewModel : ClientListViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @State private var selectedTab: ClientTab = .info
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    BluePurpleCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "person")
                                Text(clientViewModel.name)
                                    .font(.title2)
                                    .bold()
                            }

                            Divider().overlay(Color.white)

                            // Email, téléphone, adresse
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "envelope")
                                    Text(clientViewModel.email)
                                }
                                HStack {
                                    Image(systemName: "phone")
                                    Text(clientViewModel.phone) // Remplace si tu as un champ phone plus tard
                                }
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                    Text(clientViewModel.address)
                                }
                            }
                            .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                }
                if clientViewModel.clientTransactions.isEmpty {
                    Text("Aucun achat")
                }
                else {
                    VStack(spacing: 12) {
                        ForEach(clientViewModel.clientTransactions, id: \.id) { transaction in
                            HStack(alignment: .top, spacing: 16) {
                                // IMAGE DU JEU
                                AsyncImage(url: transaction.Game.photoURL) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 100, height: 100)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(10)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }

                                // INFOS TRANSACTION
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "gamecontroller.fill")
                                            .foregroundColor(.purple)
                                        Text(transaction.Game.name)
                                            .font(.headline)
                                    }

                                    HStack {
                                        Image(systemName: "tag.fill")
                                            .foregroundColor(.blue)
                                        Text(String(format: "%.2f €", transaction.depositedGame.salePrice))
                                            .font(.subheadline)
                                    }

                                    HStack {
                                        Image(systemName: "person.crop.rectangle.fill")
                                            .foregroundColor(.green)
                                        Text(transaction.seller.name)
                                            .font(.footnote)
                                    }
                                }

                                Spacer()
                            }
                            .padding()
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            
            // ne pas toucher
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    UpdateButton(destination: UpdateClientView(clientViewModel: clientViewModel))
                }
                .padding()
            }
        }
        .navigationTitle("Détail client")
        .withSessionSelector(sessionViewModel: sessionViewModel)
        .withNavigationBar()
        .onAppear {
            Task {
                await loadClientInfos(sessionId: sessionViewModel.id)
            }
        }
        .onChange(of: sessionViewModel.selectedSession.id) { newId in
            Task {
                await loadClientInfos(sessionId: newId)
                //print(clientViewModel.clientTransactions)
            }
        }
    }
    
    func loadClientInfos(sessionId: String) async {
        do {
            try await clientListViewModel.loadClientInfos(sessionId: sessionId)
        }
        catch let requestError as RequestError {
            errorMessage = requestError.message
        }
        catch {
            errorMessage = "Une erreur s'est produite."
        }
    }
}

