//
//  MainTabView.swift
//  IWA
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var selectedTab: Int = 2
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @StateObject var gameListViewModel: GameListViewModel = GameListViewModel()
    @StateObject var clientListViewModel: ClientListViewModel = ClientListViewModel()
    @StateObject var sellerListViewModel: SellerListViewModel = SellerListViewModel()

    var body: some View {
        
        VStack {
            TabView(selection: $selectedTab) {
                GameListView(gameListViewModel: gameListViewModel)
                    .tabItem {
                        Image(systemName: "gamecontroller.fill")
                        Text("Jeux")
                    }
                    .tag(0)
                    .environmentObject(sessionViewModel)

                ClientListView(clientListViewModel: clientListViewModel)
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Clients")
                    }
                    .tag(1)
                    .environmentObject(sessionViewModel)

                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(2)
                    .environmentObject(sessionViewModel)
                    .environmentObject(sellerListViewModel)
                    .environmentObject(clientListViewModel)

                SellerListView(sellerListViewModel: sellerListViewModel)
                    .tabItem {
                        Image(systemName: "person.crop.rectangle")
                        Text("Vendeurs")
                    }
                    .tag(3)
                    .environmentObject(sessionViewModel)

                BilanView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Bilan")
                    }
                    .tag(4)
                    .environmentObject(sessionViewModel)
            }
        }
        .onAppear {
            Task {
                await sessionViewModel.loadSessions()
                let sessionId = sessionViewModel.id
                Task {
                    try await gameListViewModel.loadGames()
                    try await gameListViewModel.loadDepositedGames(sessionId: sessionViewModel.id)
                }
                Task {
                    try await clientListViewModel.loadClients()
                    try await clientListViewModel.loadClientInfos(sessionId: sessionViewModel.id)
                }
                Task {
                    print("fhfhhfhfhfhfhfh", sessionViewModel.id)
                    print("gagagaga",sessionId)
                    try await sellerListViewModel.loadSellers()
                    try await sellerListViewModel.loadSellerInfos(sessionId: sessionViewModel.id)
                }
            }
            
        }
        .withNavigationBar()
        .withSessionSelector(sessionViewModel: sessionViewModel)
        
    }
}
// ⚡ Aperçu rapide
struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
