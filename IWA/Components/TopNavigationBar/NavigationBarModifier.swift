//
//  NavigationBarModifier.swift
//  IWA
//
//  Created by etud on 17/03/2025.
//

import Foundation
import SwiftUI

struct NavigationBarModifier: ViewModifier {
    @EnvironmentObject var authManager: AuthManager
    @StateObject var managerListViewModel: ManagerListViewModel = ManagerListViewModel()
    @EnvironmentObject var sessionViewModel: SessionViewModel
    func body(content: Content) -> some View {
        content
            .toolbar {
                // Bouton Profil
                ToolbarItem(placement: .navigationBarTrailing) {
                    if authManager.isAuthenticated {
                        NavigationLink(destination: ManagerListView(managerListViewModel: managerListViewModel).environmentObject(sessionViewModel)) {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    else {
                        NavigationLink(destination: LoginView()) {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                if authManager.isAdmin {
                    // Bouton admin
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ManagerListView(managerListViewModel: managerListViewModel).environmentObject(sessionViewModel)) {
                            Text("Admin")
                                .foregroundColor(.gray)
                                .font(.poppins(fontStyle: .body, fontWeight: .regular, isItalic: false))
                        }
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline) // Centrer le titre en petit
    }
}

// Extension pour une application plus propre
extension View {
    func withNavigationBar() -> some View {
        self.modifier(NavigationBarModifier())
    }
}
