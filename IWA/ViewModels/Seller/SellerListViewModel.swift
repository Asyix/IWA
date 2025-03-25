//
//  SellerListViewModel.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import Foundation
import SwiftUI

class SellerListViewModel: ObservableObject {
    @Published var sellerList: [SellerViewModel] = []
    
    func loadSellers() async throws {
        do {
            let fetchedSellers = try await SellerService.getAllSellers()
            DispatchQueue.main.async {
                if fetchedSellers.isEmpty {
                    self.sellerList = []
                }
                else
                {
                    self.sellerList = fetchedSellers.reversed().map { SellerViewModel(seller: $0) }
                }
            }
        } catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw SellerError.noSellersFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw SellerError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    func loadSellerInfos(sessionId: String) async throws {
        do {
            let fetchedDepositedGames = try await DepositedGameService.getAllDepositedGames(sessionId: sessionId)
            let fetchedGames = try await GameService.getAllGames()
            let fetchedClients = try await ClientService.getAllClients()
            let fetchedTransactions = try await TransactionService.getAllTransactions(sessionId: sessionId)
            DispatchQueue.main.async {
                // Remise à zéro des compteurs
                for index in self.sellerList.indices {
                    self.sellerList[index].nbForSale = 0
                    self.sellerList[index].nbSold = 0
                    self.sellerList[index].nbPickedUp = 0
                    self.sellerList[index].amountSold = 0
                    self.sellerList[index].depositedGames = []
                    self.sellerList[index].sellerTransactions = []
                }
                // pour chaque jeu déposé
                for depositedGame in fetchedDepositedGames {
                    //trouver le vendeur qui a déposé le jeu
                    if let index = self.sellerList.firstIndex(where: { $0.id == depositedGame.sellerId }) {
                        // trouver le jeu correspondant
                        if let gameIndex = fetchedGames.firstIndex(where: { $0.id == depositedGame.gameId }) {
                            // attribuer les jeux déposés au vendeur
                            self.sellerList[index].depositedGames.append(SellerDepositedGame(depositedGame: depositedGame, game: fetchedGames[gameIndex]))
                            // si le jeu est à vendre
                            if depositedGame.forSale {
                                //incrémenter nombre de jeux à vendre
                                self.sellerList[index].nbForSale += 1
                            }
                            // si le jeu a été recupéré
                            else if depositedGame.pickedUp {
                                //incrémenter nombre de jeux en recupérés
                                self.sellerList[index].nbPickedUp += 1
                            }
                            // si le jeu a été vendu
                            else if depositedGame.sold {
                                // trouver la transaction de vente
                                if let transactionIndex = fetchedTransactions.firstIndex(where: { $0.labelId == depositedGame.id && $0.sellerId == self.sellerList[index].id }) {
                                    // trouver le client de la transaction
                                    if let clientIndex = fetchedClients.firstIndex(where: { $0.id == fetchedTransactions [transactionIndex].clientId }) {
                                        //enregistrer les informations des transactions pour ce vendeur
                                        self.sellerList[index].sellerTransactions.append(SellerTransaction(transaction: fetchedTransactions[transactionIndex], depositedGame: depositedGame, game: fetchedGames[gameIndex], client: fetchedClients[clientIndex]))
                                    }
                                }
                                //incrémenter nombre de jeux en vendus
                                self.sellerList[index].nbSold += 1
                                //ajouter le prix au total des ventes
                                self.sellerList[index].amountSold += depositedGame.salePrice
                            }
                        }
                    }
                }
            }
        }
        catch let requestError as RequestError {
            throw RequestError.networkError(requestError)
        }
    }
    
    func create(createSellerDTO : CreateSellerDTO) async throws {
        do {
            let newSeller = try await SellerService.create(createSellerDTO: createSellerDTO)
            DispatchQueue.main.async {
                self.sellerList.insert(SellerViewModel(seller: newSeller), at: 0)
            }
        }
        catch let requestError as RequestError {
            throw SellerError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    
    subscript(index: Int) -> SellerViewModel {
        return sellerList[index]
    }
    
    // IteratorProtocol
    private var current: Int = 0
    
    /// Retourne le prochain élément dans la `gameList` tout en incrémentant l'index interne.
    /// - Precondition: `current` doit être inférieur au nombre d'éléments dans `gameList`.
    /// - Postcondition: L'index `current` est incrémenté.
    /// - Returns: L'élément de type `GameViewModel` à la position `current`, ou `nil` si la fin de la liste est atteinte.
    func next() -> SellerViewModel? {
        guard current < self.sellerList.count else { return nil }
        defer { current += 1 }
        return self.sellerList[current]
    }
    
    // RandomAccessCollection
    var startIndex: Int { return sellerList.startIndex }
    var endIndex: Int { return sellerList.endIndex }
    
    /// Retourne l'index suivant à partir d'un index donné.
    /// - Parameter i: L'index actuel à partir duquel on veut obtenir l'index suivant.
    /// - Returns: L'index suivant dans `gameList` après `i`.
    func index(after i: Int) -> Int {
        return sellerList.index(after: i)
    }
}
