//
//  TransactionListViewModel.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import Foundation
import SwiftUI

struct DepositedGameOption {
    var depositedGame: DepositedGame
    var game: Game
}

class TransactionListViewModel: ObservableObject {
    @Published var transactionList: [TransactionViewModel] = []
    
    @Published var depositedGameOptions: [DepositedGameOption] = []
    
    func loadAll(sessionId: String) async throws {
        do {
            try await loadTransactions(sessionId: sessionId)
            try await loadTransactionInfos(sessionId: sessionId)
        }
        catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw TransactionError.noTransactionsFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw TransactionError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    func loadTransactions(sessionId: String) async throws {
        do {
            let fetchedTransactions = try await TransactionService.getAllTransactions(sessionId: sessionId)
            DispatchQueue.main.async {
                if fetchedTransactions.isEmpty {
                    self.transactionList = []
                }
                else
                {
                    self.transactionList = fetchedTransactions.reversed().map { TransactionViewModel(transaction: $0) }
                }
            }
        } catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw TransactionError.noTransactionsFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw TransactionError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    func loadTransactionInfos(sessionId: String) async throws {
        do {
            let fetchedDepositedGames = try await DepositedGameService.getAllDepositedGames(sessionId: sessionId)
            let fetchedSellers = try await SellerService.getAllSellers()
            let fetchedGames = try await GameService.getAllGames()
            let fetchedClients = try await ClientService.getAllClients()
            DispatchQueue.main.async {
                // Comptage des jeux en vente
                for transaction in self.transactionList {
                    //trouver le jeu correspondant
                    if let index = fetchedDepositedGames.firstIndex(where: { $0.id == transaction.labelId }) {
                        transaction.depositedGame = fetchedDepositedGames[index]
                        if let gameIndex = fetchedGames.firstIndex(where: { $0.id == fetchedDepositedGames[index].gameId  }) {
                            transaction.game = fetchedGames[gameIndex]
                        }
                    }
                    if let index = fetchedSellers.firstIndex(where: { $0.id == transaction.sellerId }) {
                        transaction.seller = fetchedSellers[index]
                    }
                    if let index = fetchedClients.firstIndex(where: { $0.id == transaction.clientId }) {
                        transaction.client = fetchedClients[index]
                    }
                }
            }
        }
        catch let requestError as RequestError {
            throw RequestError.networkError(requestError)
        }
    }
    
    // Calcul du total généré par la vente des jeux (somme des salePrice)
    func totalGeneratedRevenue() -> Double {
        var total: Double = 0
        for transaction in transactionList {
            total += transaction.depositedGame.salePrice
        }
        return total
    }
    
    func create(createTransactionDTO : CreateTransactionDTO, sessionId: String) async throws {
        do {
            let newTransaction = try await TransactionService.create(createTransactionDTO: createTransactionDTO)
            DispatchQueue.main.async {
                self.transactionList.insert(TransactionViewModel(transaction: newTransaction), at: 0)
            }
            try await self.loadTransactionInfos(sessionId: sessionId)
        }
        catch let requestError as RequestError {
            throw TransactionError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    
    subscript(index: Int) -> TransactionViewModel {
        return transactionList[index]
    }
    
    // IteratorProtocol
    private var current: Int = 0
    
    /// Retourne le prochain élément dans la `transactionList` tout en incrémentant l'index interne.
    /// - Precondition: `current` doit être inférieur au nombre d'éléments dans `transactionList`.
    /// - Postcondition: L'index `current` est incrémenté.
    /// - Returns: L'élément de type `TransactionViewModel` à la position `current`, ou `nil` si la fin de la liste est atteinte.
    func next() -> TransactionViewModel? {
        guard current < self.transactionList.count else { return nil }
        defer { current += 1 }
        return self.transactionList[current]
    }
    
    // RandomAccessCollection
    var startIndex: Int { return transactionList.startIndex }
    var endIndex: Int { return transactionList.endIndex }
    
    /// Retourne l'index suivant à partir d'un index donné.
    /// - Parameter i: L'index actuel à partir duquel on veut obtenir l'index suivant.
    /// - Returns: L'index suivant dans `transactionList` après `i`.
    func index(after i: Int) -> Int {
        return transactionList.index(after: i)
    }
}
