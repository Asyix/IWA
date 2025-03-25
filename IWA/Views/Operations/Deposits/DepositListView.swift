//
//  DepositListView.swift
//  IWA
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct DepositListView: View {
    @StateObject var depositListViewModel: DepositListViewModel
    @EnvironmentObject private var sessionViewModel : SessionViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(depositListViewModel.depositList) { deposit in
                        // NavigationLink pour rediriger vers DepositView
                        NavigationLink(destination: DepositView(depositViewModel: deposit)
                                        .environmentObject(sessionViewModel)) {
                            DepositRowView(deposit: deposit)
                        }
                    }
                }
                .padding(.top)
               
            
            }
            // Bouton superposé (Z index : 1)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton(destination: CreateDepositView(depositListViewModel: depositListViewModel)
                        .environmentObject(sessionViewModel))
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Jeux")
        .onAppear {
            Task {
                try await depositListViewModel.loadDeposits(sessionId: sessionViewModel.id)
            }
        }
        .onChange(of: sessionViewModel.id) { newId in
            Task {
                try await depositListViewModel.loadDeposits(sessionId: newId)
            }
        }
    }
}
/*
struct GameList_Previews: PreviewProvider {
    //@StateObject var gameListViewModel : GameListViewModel = GameListViewModel()
    static var previews: some View {
        GameListView(gameListViewModel: GameListViewModel())
    }
}
*/
