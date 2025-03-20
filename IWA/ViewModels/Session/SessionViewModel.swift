//
//  SessionManager.swift
//  IWA
//
//  Created by etud on 17/03/2025.
//

import Foundation

import SwiftUI

class SessionViewModel: ObservableObject {
    @Published var currentSession: Session?
    @Published var selectedSession: Session
    @Published var sessions: [Session] = []
    
    var id: String { selectedSession.id }
    var name: String { selectedSession.name }
    var location: String { selectedSession.location }
    var startDate: Date { selectedSession.startDate }
    var endDate: Date { selectedSession.endDate }
    var description: String? { selectedSession.description }
    var depositFee: Double { selectedSession.depositFee }
    var depositFeeLimitBeforeDiscount: Double { selectedSession.depositFeeLimitBeforeDiscount }
    var depositFeeDiscount: Double { selectedSession.depositFeeDiscount }
    var saleComission: Double { selectedSession.saleComission }
    var managerId: String { selectedSession.managerId }
    
    
    init() {
        self.selectedSession = Session(from: SessionDTO(_id: "0", name: "Aucune Session", location: "N/A", startDate: "N/A", endDate: "N/A", depositFee: 0.0, depositFeeLimitBeforeDiscount: 0.0, depositFeeDiscount: 0.0, saleComission: 0.0, managerId: "0"))
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
                if let currentSession = fetchedSessions.first(where: { session in
                    session.startDate <= now && session.endDate >= now
                }) {
                    self.currentSession = currentSession
                    self.selectedSession = currentSession
                }
                else if let firstSession = fetchedSessions.first {
                    self.selectedSession = firstSession
                } // Sélectionne la première session par défaut
            }
        } catch {
            print("Erreur lors du chargement des sessions : \(error)")
        }
    }
    
    func selectSession(_ session: Session) {
        selectedSession = session
    }
    
    func create(createSessionDto : CreateSessionDTO) async {
        do {
            let newSession = try await SessionService.create(createSessionDto: createSessionDto)
            DispatchQueue.main.async {
                self.sessions.append(newSession)
                self.sessions.sort { $0.startDate > $1.startDate } // Sorts sessions in descending order by date (most recent first)
            }
        }
        catch {
            print("Erreur : \(error)")
        }
    }
    
    func update(name: String, location: String, description: String?, startDate: Date, endDate: Date, depositFee: Double, depositFeeLimitBeforeDiscount: Double, depositFeeDiscount: Double, saleComission: Double) async {
        do {
            let updateSessionDto = UpdateSessionDTO(id: selectedSession.id, name: name, location: location, startDate: startDate, endDate: endDate, depositFee: depositFee, depositFeeLimitBeforeDiscount: depositFeeLimitBeforeDiscount, depositFeeDiscount: depositFeeDiscount, saleComission: saleComission)
            let updatedSession = try await SessionService.updateSessionById(updateSessionDto: updateSessionDto)
            DispatchQueue.main.async {
                // Update the selected session
                self.selectedSession = updatedSession

                // Find and replace the updated session in the list
                if let index = self.sessions.firstIndex(where: { $0.id == updatedSession.id }) {
                    self.sessions[index] = updatedSession
                }
            }
        }
        catch {
            print("Erreur : \(error)")
        }
    }
    
    func delete() async {
        do {
            try await SessionService.deleteSessionById(session: self.selectedSession)
            DispatchQueue.main.async {
                self.sessions.removeAll { $0.id == self.selectedSession.id }
                if self.selectedSession.id == self.currentSession?.id {
                    self.currentSession = nil
                }
                            
                // Reset selectedSession to a default or the next available session
                if let currentSession = self.currentSession {
                    self.selectedSession = currentSession
                }
                else if let firstSession = self.sessions.first {
                    self.selectedSession = firstSession
                } else {
                    self.selectedSession = Session(from: SessionDTO(_id: "0", name: "Aucune Session", location: "N/A", startDate: "N/A", endDate: "N/A", depositFee: 0.0, depositFeeLimitBeforeDiscount: 0.0, depositFeeDiscount: 0.0, saleComission: 0.0, managerId: "0"))
                }
            }
        }
        catch {
            print("Erreur : \(error)")
        }
    }
}
