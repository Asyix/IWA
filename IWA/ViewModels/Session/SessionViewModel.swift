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
    @Published var selectedSession: Session = Session(from: SessionDTO(_id: "0", name: "Aucune Session", location: "N/A", startDate: "N/A", endDate: "N/A", depositFee: 0.0, depositFeeLimitBeforeDiscount: 0.0, depositFeeDiscount: 0.0, saleComission: 0.0, managerId: "0"))
    @Published var sessions: [Session] = []
    
    var id: String { selectedSession.id }
    var name: String {
        get { selectedSession.name }
        set { selectedSession.name = newValue; objectWillChange.send() }
    }
    var location: String {
        get { selectedSession.location }
        set { selectedSession.location = newValue; objectWillChange.send() }
    }
    var startDate: Date {
        get { selectedSession.startDate }
        set { selectedSession.startDate = newValue; objectWillChange.send() }
    }
    var endDate: Date {
        get { selectedSession.endDate }
        set { selectedSession.endDate = newValue; objectWillChange.send() }
    }
    var description: String? {
        get { selectedSession.description }
        set { selectedSession.description = newValue; objectWillChange.send() }
    }
    var depositFee: Double {
        get { selectedSession.depositFee }
        set { selectedSession.depositFee = newValue; objectWillChange.send() }
    }
    var depositFeeLimitBeforeDiscount: Double {
        get { selectedSession.depositFeeLimitBeforeDiscount }
        set { selectedSession.depositFeeLimitBeforeDiscount = newValue; objectWillChange.send() }
    }
    var depositFeeDiscount: Double {
        get { selectedSession.depositFeeDiscount }
        set { selectedSession.depositFeeDiscount = newValue; objectWillChange.send() }
    }
    var saleComission: Double {
        get { selectedSession.saleComission }
        set { selectedSession.saleComission = newValue; objectWillChange.send() }
    }
    var managerId: String {
        get { selectedSession.managerId }
        set { selectedSession.managerId = newValue; objectWillChange.send() }
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
    
    func create(createSessionDto : CreateSessionDTO) async throws {
        do {
            let newSession = try await SessionService.create(createSessionDto: createSessionDto)
            DispatchQueue.main.async {
                self.sessions.append(newSession)
                self.sessions.sort { $0.startDate > $1.startDate } // Sorts sessions in descending order by date (most recent first)
            }
        }
        catch let requestError as RequestError {
            throw SessionError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    func update(name: String, location: String, description: String?, startDate: Date, endDate: Date, depositFee: Double, depositFeeLimitBeforeDiscount: Double, depositFeeDiscount: Double, saleComission: Double) async throws {
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
        catch let requestError as RequestError {
            throw SessionError.requestError(requestError) // Pass the caught RequestError
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
