//
//  Transaction.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import Foundation

class Transaction: ObservableObject, Hashable {
    private(set) var id: String
    @Published var labelId: String
    @Published var sessionId: String
    @Published var sellerId: String
    @Published var clientId: String
    @Published var managerId: String
    @Published var transactionDate: Date

    init(from dto: TransactionDTO) {
        self.id = dto._id
        self.labelId = dto.labelId
        self.sessionId = dto.sessionId
        self.sellerId = dto.sellerId
        self.clientId = dto.clientId
        self.managerId = dto.managerId
        self.transactionDate = JSONHelper.dateFormatter.date(from: dto.transactionDate) ?? Date()
    }

    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// DTO utilisé pour décoder les données depuis le backend
struct TransactionDTO: Codable {
    var _id: String
    var labelId: String
    var sessionId: String
    var sellerId: String
    var clientId: String
    var managerId: String
    var transactionDate: String  // au format ISO8601 en général
}

// DTO utilisé pour créer une transaction
struct CreateTransactionDTO: Codable {
    var labelId: String
    var sessionId: String
    var sellerId: String
    var clientId: String
    var transactionDate: Date
}

struct UpdateTransactionDTO: Codable {
    var _id: String
    var labelId: String
    var sessionId: String
    var sellerId: String
    var clientId: String
    var managerId: String
    var transactionDate: Date
}
