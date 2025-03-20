//
//  IWAApp.swift
//  IWA
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

@main
struct IWAApp: App {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var sessionViewModel = SessionViewModel() // Ajout du SessionManager

    @Environment(\.scenePhase) private var scenePhase // Écoute les changements d'état de l'application

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(sessionViewModel)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background || newPhase == .inactive {
                // Déconnexion automatique lorsque l'application passe en arrière-plan ou devient inactive
                authManager.logout()
            }
        }
    }
}
