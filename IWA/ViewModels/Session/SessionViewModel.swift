//
//  SessionManager.swift
//  IWA
//
//  Created by etud on 17/03/2025.
//

import Foundation

import SwiftUI

class SessionManager: ObservableObject {
    @Published var currentSession: Session?
    @Published var selectedSession: Session?
    @Published var sessions: [Session] = []
    
    init() {
        Task {
            await loadSessions()
        }
    }
    
    func loadSessions() async {
        do {
            let fetchedSessions = try await SessionService.getAllSessions()
            DispatchQueue.main.async {
                self.sessions = fetchedSessions
                
                let now = Date()
                // Find the first session that is currently active
                self.currentSession = fetchedSessions.first { session in
                    session.startDate <= now && session.endDate >= now
                }
                
                self.selectedSession = self.currentSession ?? fetchedSessions.first // Sélectionne la première session par défaut
            }
        } catch {
            print("Erreur lors du chargement des sessions : \(error)")
        }
    }
    
    func selectSession(_ session: Session) {
        selectedSession = session
    }
}
