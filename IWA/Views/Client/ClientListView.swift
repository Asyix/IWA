//
//  ClientsView.swift
//  IWA
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct ClientListView: View {
    @EnvironmentObject private var sessionViewModel : SessionViewModel
    @ObservedObject var clientListViewModel: ClientListViewModel
    @State var lastSessionId : String = "x"
    
    var body: some View {
        ZStack {
            ScrollView {
                Text("caca")
                VStack(spacing: 8) {
                    ForEach(clientListViewModel.clientList) { client in
                        NavigationLink(destination: ClientView(clientViewModel: client, clientListViewModel: clientListViewModel).environmentObject(sessionViewModel)) {
                            ClientRowView(clientViewModel: client)
                                .frame(maxWidth: .infinity)
                                .environmentObject(sessionViewModel)
                        }
                    }
                }
                .padding(.top)
            }
            //ne pas toucher
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton(destination: CreateClientView(clientListViewModel: clientListViewModel))
                }
                .padding()
            }
        }
        .navigationTitle("Clients")
        .onAppear {
            lastSessionId = sessionViewModel.id
            Task {
                try await clientListViewModel.loadClients()
                try await clientListViewModel.loadClientInfos(sessionId: sessionViewModel.id)
            }
        }
        .onChange(of: sessionViewModel.id) { newId in
            Task {
                try await clientListViewModel.loadClientInfos(sessionId: newId)
            }
        }
    }
}

