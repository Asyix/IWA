//
//  ManagerListView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct ManagerListView: View {
    @StateObject var managerListViewModel: ManagerListViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(managerListViewModel.managerList) { manager in
                        NavigationLink(destination: ManagerView(managerViewModel: manager)
                                        .environmentObject(sessionViewModel)) {
                            ManagerRowView(manager: manager)
                        }
                    }
                }
                .padding(.top)
            }
            
            // Bouton superposé pour ajouter un manager
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton(destination: CreateManagerView(managerListViewModel: managerListViewModel))
                }
                .padding()
            }
        }
        .navigationTitle("Managers")
        .onAppear {
            Task {
                try await managerListViewModel.loadManagers()
                try await managerListViewModel.loadManangerInfos(sessionId: sessionViewModel.id)
            }
        }
        .onChange(of: sessionViewModel.id) { newId in
            Task {
                try await managerListViewModel.loadManangerInfos(sessionId: newId)
            }
        }
    }
}
    

