//
//  AuthManager.swift
//  IWA
//
//  Created by etud on 16/03/2025.
//

import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    @Published var isAuthenticated = false

    private init() {
        // Vérifie si un token existe déjà au démarrage
        isAuthenticated = KeychainHelper.shared.hasToken()
    }

    // Méthode de déconnexion
    func logout() {
        // Supprime le token du Keychain
        KeychainHelper.shared.deleteToken()
        
        // Met à jour l'état d'authentification
        isAuthenticated = false
    }
}
