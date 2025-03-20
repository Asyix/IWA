//
//  MainTabView.swift
//  IWA
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var selectedTab: TabItem = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabItem.allCases) { tab in
                tab.view
                    .tabItem {
                        Image(systemName: tab.icon)
                        Text(tab.rawValue)
                    }
                    .tag(tab)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Déconnexion
                    authManager.logout()
                }) {
                    Text("Déconnexion")
                        .foregroundColor(.red)
                }
            }
        }
    }
}
// ⚡ Aperçu rapide
struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
