//
//  GameViewModel.swift
//  IWA
//
//  Created by etud on 21/03/2025.
//

import Foundation
import SwiftUI

// Cette View est la vue de détail d'un jeu
// Ajoute la pubished var currentGame qui est le jeu dont on affiche le détail

struct SaleOption: Identifiable {
    let id = UUID()
    var seller : Seller
    var price: Double
    var quantity: Int
}

class GameViewModel : ObservableObject, Equatable, Hashable, Identifiable {
    @Published var game: Game
    
    @Published var saleOptions: [SaleOption] = []
    @Published var pickedUp: Int = 0
    @Published var sold: Int = 0
    @Published var nbForSale: Int = 0
        
    init(game: Game) { self.game = game }
    
    var id: String { game.id }
    var name: String {
        get { game.name }
        set { game.name = newValue; objectWillChange.send() }
    }
    var publisher: String {
        get { game.publisher }
        set { game.publisher = newValue; objectWillChange.send() }
    }
    var description: String {
        get { game.description }
        set { game.description = newValue; objectWillChange.send() }
    }
    var minPlayers: Int {
        get { game.minPlayers }
        set { game.minPlayers = newValue; objectWillChange.send() }
    }
    var maxPlayers: Int {
        get { game.maxPlayers }
        set { game.maxPlayers = newValue; objectWillChange.send() }
    }
    var ageRange: AgeRange {
        get { game.ageRange }
        set { game.ageRange = newValue; objectWillChange.send() }
    }
    var photoURL: URL? {
        get { game.photoURL }
        set { game.photoURL = newValue; objectWillChange.send() }
    }

    
    
    
    static func == (lhs: GameViewModel, rhs: GameViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func updateGame(gameDTO : GameDTO) async throws {
        do {
            let updatedGame = try await GameService.updateGameById(gameDTO: gameDTO)
            // Update the selected game
            DispatchQueue.main.async {
                if updatedGame.id == self.game.id {
                    self.name = updatedGame.name
                    self.publisher = updatedGame.publisher
                    self.description = updatedGame.description
                    self.minPlayers = updatedGame.minPlayers
                    self.maxPlayers = updatedGame.maxPlayers
                    self.photoURL = updatedGame.photoURL
                    self.ageRange = updatedGame.ageRange
                }
            }
        }
        catch let requestError as RequestError {
            throw GameError.requestError(requestError) // Pass the caught RequestError
        }
    }
}
