//
//  GameListViewModel.swift
//  IWA
//
//  Created by etud on 21/03/2025.
//

import Foundation
import SwiftUI

class GameListViewModel: ObservableObject {
    @Published var gameList: [GameViewModel] = []
    
    func loadGames() async throws {
        do {
            let fetchedGames = try await GameService.getAllGames()
            DispatchQueue.main.async {
                if fetchedGames.isEmpty {
                    self.gameList = []
                }
                else
                {
                    self.gameList = fetchedGames.reversed().map { GameViewModel(game: $0) }
                }
            }
        } catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw GameError.noGamesFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw GameError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    func loadDepositedGames(sessionId: String) async throws {
        do {
            let fetchedDepositedGames = try await DepositedGameService.getAllDepositedGames(sessionId: sessionId)
            let fetchedSellers = try await SellerService.getAllSellers()
            DispatchQueue.main.async {
                // Remise à zéro des compteurs
                for index in self.gameList.indices {
                    self.gameList[index].nbForSale = 0
                    self.gameList[index].sold = 0
                    self.gameList[index].pickedUp = 0
                }
                
                // Comptage des jeux en vente
                for depositedGame in fetchedDepositedGames {
                    //trouver le jeu correspondant
                    if let index = self.gameList.firstIndex(where: { $0.id == depositedGame.gameId }) {
                        // si le jeu est à vendre
                        if depositedGame.forSale {
                            //incrémenter nombre de jeux en stock
                            self.gameList[index].nbForSale += 1
                            self.gameList[index].objectWillChange.send()
                            // ajouter les options de vente
                            let sellerId = depositedGame.sellerId
                            let price = depositedGame.salePrice
                            // Check if a sale option already exists for this seller
                            if let existingOptionIndex = self.gameList[index].saleOptions.firstIndex(where: { $0.seller.id == sellerId && $0.price == price }) {
                                self.gameList[index].saleOptions[existingOptionIndex].quantity += 1
                            } else {
                                if let sellerIndex = fetchedSellers.firstIndex(where: { $0.id == depositedGame.sellerId }) {
                                    let newOption = SaleOption(seller: fetchedSellers[sellerIndex], price: price, quantity: 1)
                                    self.gameList[index].saleOptions.append(newOption)
                                    self.gameList[index].saleOptions.sort { $0.price < $1.price }
                                }
                                
                            }
                        }
                        // si le jeu a été recupéré
                        else if depositedGame.pickedUp {
                                //incrémenter nombre de jeux en stock
                                self.gameList[index].pickedUp += 1
                        }
                        // si le jeu a été vendu
                        else if depositedGame.sold {
                                //incrémenter nombre de jeux en stock
                                self.gameList[index].sold += 1
                        }
                    }
                }
            }
        }
        catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw DepositedGameError.noDepositedGamesFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw DepositedGameError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    func create(createGameDTO : CreateGameDTO) async throws {
        do {
            let newGame = try await GameService.create(createGameDTO: createGameDTO)
            DispatchQueue.main.async {
                self.gameList.insert(GameViewModel(game: newGame), at: 0)            }
        }
        catch let requestError as RequestError {
            throw GameError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    
    subscript(index: Int) -> GameViewModel {
        return gameList[index]
    }
    
    // IteratorProtocol
    private var current: Int = 0
    
    /// Retourne le prochain élément dans la `gameList` tout en incrémentant l'index interne.
    /// - Precondition: `current` doit être inférieur au nombre d'éléments dans `gameList`.
    /// - Postcondition: L'index `current` est incrémenté.
    /// - Returns: L'élément de type `GameViewModel` à la position `current`, ou `nil` si la fin de la liste est atteinte.
    func next() -> GameViewModel? {
        guard current < self.gameList.count else { return nil }
        defer { current += 1 }
        return self.gameList[current]
    }
    
    // RandomAccessCollection
    var startIndex: Int { return gameList.startIndex }
    var endIndex: Int { return gameList.endIndex }
    
    /// Retourne l'index suivant à partir d'un index donné.
    /// - Parameter i: L'index actuel à partir duquel on veut obtenir l'index suivant.
    /// - Returns: L'index suivant dans `gameList` après `i`.
    func index(after i: Int) -> Int {
        return gameList.index(after: i)
    }
}
