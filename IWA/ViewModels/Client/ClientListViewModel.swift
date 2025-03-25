//
//  ClientListViewModel.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import Foundation
import SwiftUI

class ClientListViewModel: ObservableObject {
    @Published var clientList: [ClientViewModel] = []
    
    func loadClients() async throws {
        do {
            let fetchedClients = try await ClientService.getAllClients()
            DispatchQueue.main.async {
                if fetchedClients.isEmpty {
                    self.clientList = []
                }
                else
                {
                    self.clientList = fetchedClients.reversed().map { ClientViewModel(client: $0) }
                }
            }
        } catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw ClientError.noClientsFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw ClientError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    func loadClientInfos(sessionId: String) async throws {
        do {
            let fetchedDepositedGames = try await DepositedGameService.getAllDepositedGames(sessionId: sessionId)
            let fetchedGames = try await GameService.getAllGames()
            let fetchedSellers = try await SellerService.getAllSellers()
            let fetchedTransactions = try await TransactionService.getAllTransactions(sessionId: sessionId)
            DispatchQueue.main.async {
                // Remise à zéro des compteurs
                for index in self.clientList.indices {
                    self.clientList[index].nbBought = 0
                    self.clientList[index].amountSpent = 0
                    self.clientList[index].clientTransactions.removeAll()
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                }
                
                // pour chaque jeu déposé
                for transaction in fetchedTransactions {
                    //trouver le client qui fait partie de la transaction
                    if let index = self.clientList.firstIndex(where: { $0.id == transaction.clientId }) {
                        // trouver le jeu déposé de la transaction
                        if let depGameIndex = fetchedDepositedGames.firstIndex(where: { $0.id == transaction.labelId }) {
                            // trouver le vendeur de la transaction
                            if let sellerIndex = fetchedSellers.firstIndex(where: { $0.id == transaction.sellerId }) {
                                //trouver le jeu correspondant au jeu déposé
                                if let gameIndex = fetchedGames.firstIndex(where: { $0.id == fetchedDepositedGames[depGameIndex].gameId }) {
                                    //enregistrer les informations des transactions pour ce client
                                    self.clientList[index].clientTransactions.append(ClientTransaction(transaction: transaction, depositedGame: fetchedDepositedGames[depGameIndex], Game: fetchedGames[gameIndex], seller: fetchedSellers[sellerIndex]))
                                    // ajouter au montant dépensé
                                    self.clientList[index].amountSpent += fetchedDepositedGames[depGameIndex].salePrice
                                    //incrémenter nombre de jeux achetés
                                    self.clientList[index].nbBought += 1
                                }
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
    
    func create(createClientDTO : CreateClientDTO) async throws {
        do {
            let newClient = try await ClientService.create(createClientDTO: createClientDTO)
            DispatchQueue.main.async {
                self.clientList.insert(ClientViewModel(client: newClient), at: 0)
            }
        }
        catch let requestError as RequestError {
            throw ClientError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    
    subscript(index: Int) -> ClientViewModel {
        return clientList[index]
    }
    
    // IteratorProtocol
    private var current: Int = 0
    
    /// Retourne le prochain élément dans la `gameList` tout en incrémentant l'index interne.
    /// - Precondition: `current` doit être inférieur au nombre d'éléments dans `gameList`.
    /// - Postcondition: L'index `current` est incrémenté.
    /// - Returns: L'élément de type `GameViewModel` à la position `current`, ou `nil` si la fin de la liste est atteinte.
    func next() -> ClientViewModel? {
        guard current < self.clientList.count else { return nil }
        defer { current += 1 }
        return self.clientList[current]
    }
    
    // RandomAccessCollection
    var startIndex: Int { return clientList.startIndex }
    var endIndex: Int { return clientList.endIndex }
    
    /// Retourne l'index suivant à partir d'un index donné.
    /// - Parameter i: L'index actuel à partir duquel on veut obtenir l'index suivant.
    /// - Returns: L'index suivant dans `gameList` après `i`.
    func index(after i: Int) -> Int {
        return clientList.index(after: i)
    }
}
