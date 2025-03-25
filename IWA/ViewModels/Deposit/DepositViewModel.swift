//
//  DepositViewModel.swift
//  IWA
//
//  Created by etud on 24/03/2025.
//

import SwiftUI


class DepositViewModel : ObservableObject, Equatable, Hashable, Identifiable {
    @Published var depositedGame: DepositedGame
    @Published var name: String = ""
    @Published var photoURL: URL? = nil
    @Published var seller: Seller = Seller()
    
    init(depositedGame: DepositedGame) {
            self.depositedGame = depositedGame
        }
        
        var id: String { depositedGame.id }
        
        var salePrice: Double {
            get { depositedGame.salePrice }
            set { depositedGame.salePrice = newValue; objectWillChange.send() }
        }
        
        var sold: Bool {
            get { depositedGame.sold }
            set { depositedGame.sold = newValue; objectWillChange.send() }
        }
        
        var forSale: Bool {
            get { depositedGame.forSale }
            set { depositedGame.forSale = newValue; objectWillChange.send() }
        }
        
        var pickedUp: Bool {
            get { depositedGame.pickedUp }
            set { depositedGame.pickedUp = newValue; objectWillChange.send() }
        }
        
        var sessionId: String {
            get { depositedGame.sessionId }
            set { depositedGame.sessionId = newValue; objectWillChange.send() }
        }
        
        var sellerId: String {
            get { depositedGame.sellerId }
            set { depositedGame.sellerId = newValue; objectWillChange.send() }
        }
        
        var gameId: String {
            get { depositedGame.gameId }
            set { depositedGame.gameId = newValue; objectWillChange.send() }
        }
        
        static func == (lhs: DepositViewModel, rhs: DepositViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
    func updateDepositedGame(depositedGameDTO: DepositedGameDTO) async throws {
        do {
            let updatedDepositedGame = try await DepositedGameService.updateGameById(depositedGameDTO: depositedGameDTO)
            DispatchQueue.main.async {
                if updatedDepositedGame.id == self.id {
                    self.salePrice = updatedDepositedGame.salePrice
                    self.sold = updatedDepositedGame.sold
                    self.forSale = updatedDepositedGame.forSale
                    self.pickedUp = updatedDepositedGame.pickedUp
                    self.sessionId = updatedDepositedGame.sessionId
                    self.sellerId = updatedDepositedGame.sellerId
                    self.gameId = updatedDepositedGame.gameId
                }
            }
        } catch let requestError as RequestError {
            throw DepositedGameError.requestError(requestError)
        }
    }
}

