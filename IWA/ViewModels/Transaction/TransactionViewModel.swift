//
//  TransactionViewModel.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import Foundation
import SwiftUI

class TransactionViewModel : ObservableObject, Equatable, Hashable, Identifiable {
    @Published var transaction: Transaction
    @Published var depositedGame: DepositedGame = DepositedGame()
    @Published var seller: Seller = Seller()
    @Published var game: Game = Game()
    @Published var client: Client = Client()
    
    init(transaction: Transaction) { self.transaction = transaction}
    
    var id: String { transaction.id }
    var labelId: String {
        get { transaction.labelId }
        set { transaction.labelId = newValue; objectWillChange.send() }
    }
    var sessionId: String {
        get { transaction.sessionId }
        set { transaction.sessionId = newValue; objectWillChange.send() }
    }
    var sellerId: String {
        get { transaction.sellerId }
        set { transaction.sellerId = newValue; objectWillChange.send() }
    }
    var clientId: String {
        get { transaction.clientId }
        set { transaction.clientId = newValue; objectWillChange.send() }
    }
    var managerId: String {
        get { transaction.managerId }
        set { transaction.managerId = newValue; objectWillChange.send() }
    }
    var transactionDate: Date {
        get { transaction.transactionDate }
        set { transaction.transactionDate = newValue; objectWillChange.send() }
    }

    // MARK: - Equatable & Hashable

    static func == (lhs: TransactionViewModel, rhs: TransactionViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

