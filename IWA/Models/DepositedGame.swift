//
//  DepositedGame.swift
//  IWA
//
//  Created by etud on 21/03/2025.
//

import Foundation

class DepositedGame: ObservableObject, Hashable {
    private(set) var id: String
    @Published var salePrice: Double
    @Published var sold: Bool
    @Published var forSale: Bool
    @Published var pickedUp: Bool
    @Published var sessionId: String
    @Published var sellerId: String
    @Published var gameId: String
    
    init(from dto: DepositedGameDTO) {
        self.id = dto._id
        self.salePrice = dto.salePrice
        self.sold = dto.sold
        self.forSale = dto.forSale
        self.pickedUp = dto.pickedUp
        self.sessionId = dto.sessionId
        self.sellerId = dto.sellerId
        self.gameId = dto.gameDescriptionId
    }
    
    init() {
        self.id = "0"
        self.salePrice = 0
        self.sold = false
        self.forSale = false
        self.pickedUp = false
        self.sessionId = "0"
        self.sellerId = "0"
        self.gameId = "0"
    }
    
    func update(from updated: DepositedGame) {
        self.salePrice = updated.salePrice
        self.sold = updated.sold
        self.forSale = updated.forSale
        self.pickedUp = updated.pickedUp
        self.sessionId = updated.sessionId
        self.sellerId = updated.sellerId
        self.gameId = updated.gameId
    }
    
    
    static func == (lhs: DepositedGame, rhs: DepositedGame) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct DepositedGameDTO: Codable {
    var _id: String  // L'ID est généré par la base
    var salePrice: Double
    var sold: Bool
    var forSale: Bool
    var pickedUp: Bool
    var sessionId: String
    var sellerId: String
    var gameDescriptionId: String
}

struct CreateDepositedGameDTO: Codable {
    var salePrice: Double
    var sold: Bool
    var forSale: Bool
    var pickedUp: Bool
    var sessionId: String
    var sellerId: String
    var gameDescriptionId: String
}
    
