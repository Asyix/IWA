//
//  SellerViewModel.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import Foundation
import SwiftUI

struct SellerTransaction : Identifiable {
    let id = UUID()
    var transaction: Transaction
    var depositedGame: DepositedGame
    var game: Game
    var client: Client
}

struct SellerDepositedGame : Identifiable {
    let id = UUID()
    var depositedGame: DepositedGame
    var game: Game
}

class SellerViewModel : ObservableObject, Equatable, Hashable, Identifiable {
    @Published var seller: Seller
    @Published var nbForSale: Int = 0
    @Published var nbPickedUp: Int = 0
    @Published var nbSold: Int = 0
    @Published var amountSold: Double = 0
    @Published var sellerTransactions: [SellerTransaction] = []
    @Published var depositedGames: [SellerDepositedGame] = []
        
    init(seller: Seller) { self.seller = seller}
    
    var id: String { seller.id }
    var name: String {
        get { seller.name }
        set { seller.name = newValue; objectWillChange.send() }
    }
    var email: String {
        get { seller.email }
        set { seller.email = newValue; objectWillChange.send() }
    }
    var phone: String {
        get { seller.phone }
        set { seller.phone = newValue; objectWillChange.send() }
    }
    var amountOwed: Double {
        get { seller.amountOwed }
        set { seller.amountOwed = newValue; objectWillChange.send() }
    }

    
    
    
    static func == (lhs: SellerViewModel, rhs: SellerViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func updateSeller(sellerDTO : SellerDTO) async throws {
        do {
            let updatedSeller = try await SellerService.updateSellerById(sellerDTO: sellerDTO)
            // Update the selected game
            DispatchQueue.main.async {
                if updatedSeller.id == self.id {
                    self.name = updatedSeller.name
                    self.email = updatedSeller.email
                    self.phone = updatedSeller.phone
                    self.amountOwed = updatedSeller.amountOwed
                }
            }
        }
        catch let requestError as RequestError {
            throw SellerError.requestError(requestError) // Pass the caught RequestError
        }
    }
}

