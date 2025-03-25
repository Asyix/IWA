//
//  ClientViewModel.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import Foundation
import SwiftUI

struct ClientTransaction : Identifiable {
    let id = UUID()
    var transaction: Transaction
    var depositedGame: DepositedGame
    var Game: Game
    var seller: Seller
}

class ClientViewModel : ObservableObject, Equatable, Hashable, Identifiable {
    @Published var client: Client
    @Published var nbBought: Int = 0
    @Published var amountSpent: Double = 0
    @Published var clientTransactions: [ClientTransaction] = []
        
    init(client: Client) { self.client = client}
    
    var id: String { client.id }
    var name: String {
        get { client.name }
        set { client.name = newValue; objectWillChange.send() }
    }
    var email: String {
        get { client.email }
        set { client.email = newValue; objectWillChange.send() }
    }
    var phone: String {
        get { client.phone }
        set { client.phone = newValue; objectWillChange.send() }
    }
    var address: String {
        get { client.address }
        set { client.address = newValue; objectWillChange.send() }
    }

    static func == (lhs: ClientViewModel, rhs: ClientViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func updateClient(clientDTO : ClientDTO) async throws {
        do {
            let updatedClient = try await ClientService.updateClientById(clientDTO: clientDTO)
            // Update the selected game
            DispatchQueue.main.async {
                if updatedClient.id == self.id {
                    self.name = updatedClient.name
                    self.email = updatedClient.email
                    self.address = updatedClient.address
                    self.phone = updatedClient.phone
                }
            }
        }
        catch let requestError as RequestError {
            throw ClientError.requestError(requestError) // Pass the caught RequestError
        }
    }
}


