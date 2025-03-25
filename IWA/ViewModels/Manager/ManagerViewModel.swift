//
//  ManagerViewModel.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct ManagerTransaction: Identifiable {
    let id = UUID()
    var transaction: Transaction
    var depositedGame: DepositedGame
    var game: Game
    var client: Client
    var seller: Seller  // Updated to Manager instead of Seller
}

struct ManagerDepositedGame: Identifiable {
    let id = UUID()
    var depositedGame: DepositedGame
    var game: Game
    var seller: Seller  // Updated to Manager instead of Seller
}

class ManagerViewModel: ObservableObject, Equatable, Hashable, Identifiable {
    @Published var manager: Manager
    @Published var managerTransactions: [ManagerTransaction] = []  // Renamed for manager context
    @Published var depositedGames: [ManagerDepositedGame] = []  // Renamed for manager context
    
    init(manager: Manager) {
        self.manager = manager
    }
    
    var id: String { manager.id }
    
    var firstName: String {
        get { manager.firstName }
        set { manager.firstName = newValue; objectWillChange.send() }
    }
    
    var lastName: String {
        get { manager.lastName }
        set { manager.lastName = newValue; objectWillChange.send() }
    }
    
    var email: String {
        get { manager.email }
        set { manager.email = newValue; objectWillChange.send() }
    }
    
    var phone: String {
        get { manager.phone }
        set { manager.phone = newValue; objectWillChange.send() }
    }
    
    var address: String {
        get { manager.address }
        set { manager.address = newValue; objectWillChange.send() }
    }
    
    var admin: Bool {
        get { manager.admin }
        set { manager.admin = newValue; objectWillChange.send() }
    }

    static func == (lhs: ManagerViewModel, rhs: ManagerViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func updateManager(managerDTO: ManagerDTO) async throws {
        do {
            let updatedManager = try await ManagerService.updateManagerById(managerDTO: managerDTO)
            // Update the selected manager
            DispatchQueue.main.async {
                if updatedManager.id == self.id {
                    self.firstName = updatedManager.firstName
                    self.lastName = updatedManager.lastName
                    self.email = updatedManager.email
                    self.phone = updatedManager.phone
                    self.address = updatedManager.address
                    self.admin = updatedManager.admin
                }
            }
        } catch let requestError as RequestError {
            throw ManagerError.requestError(requestError) // Pass the caught RequestError
        }
    }
}
