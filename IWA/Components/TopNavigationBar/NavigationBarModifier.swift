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
    func body(content: Content) -> some View {
        content
            .toolbar {
                // Bouton Profil
                ToolbarItem(placement: .navigationBarTrailing) {
                    if authManager.isAuthenticated {
                        NavigationLink(destination: ProfileView()) {
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
                
                // Bouton Paramètres
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.gray)
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
