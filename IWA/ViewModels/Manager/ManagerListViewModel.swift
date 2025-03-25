//
//  ManagerListViewModel.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import Foundation
import SwiftUI

class ManagerListViewModel: ObservableObject {
    @Published var managerList: [ManagerViewModel] = []
    
    func loadManagers() async throws {
        do {
            let fetchedManagers = try await ManagerService.getAllManagers()
            DispatchQueue.main.async {
                if fetchedManagers.isEmpty {
                    self.managerList = []
                }
                else
                {
                    self.managerList = fetchedManagers.reversed().map { ManagerViewModel(manager: $0) }
                }
            }
        } catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw ManagerError.noManagersFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw ManagerError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    func loadManangerInfos(sessionId: String) async throws {
        do {
            let fetchedSellers = try await SellerService.getAllSellers()
            let fetchedDepositedGames = try await DepositedGameService.getAllDepositedGames(sessionId: sessionId)
            let fetchedGames = try await GameService.getAllGames()
            let fetchedClients = try await ClientService.getAllClients()
            let fetchedTransactions = try await TransactionService.getAllTransactions(sessionId: sessionId)
            DispatchQueue.main.async {
                // Remise à zéro des compteurs
                for index in self.managerList.indices {
                    self.managerList[index].managerTransactions = []
                }
                // pour chaque transaction
                for transaction in fetchedTransactions {
                    //trouver une transaction opérée par le manager
                    if let index = self.managerList.firstIndex(where: { $0.id == transaction.sellerId }) {
                        // trouver le jeu déposé correspondant
                        if let depositedGameIndex = fetchedDepositedGames.firstIndex(where: { $0.id == transaction.labelId }) {
                            // trouver le jeu correspondant
                            if let gameIndex = fetchedGames.firstIndex(where: { $0.id == fetchedDepositedGames[depositedGameIndex].gameId}) {
                                //trouver le client correspondant
                                if let clientIndex = fetchedClients.firstIndex(where: { $0.id == transaction.clientId }) {
                                    //trouver le vendeur correspondant
                                    if let sellerIndex = fetchedSellers.firstIndex(where: { $0.id == transaction.sellerId}) {
                                        //enregistrer les informations
                                        self.managerList[index].managerTransactions.append(ManagerTransaction(transaction: transaction, depositedGame: fetchedDepositedGames[depositedGameIndex], game: fetchedGames[gameIndex], client: fetchedClients[clientIndex], seller: fetchedSellers[sellerIndex]))
                                    }
                                }
                            }
                        }
                    }
                }
                for index in self.managerList.indices {
                    // trier les transactions par date la plus récente
                    self.managerList[index].managerTransactions.sort(by: { $0.transaction.transactionDate > $1.transaction.transactionDate })
                }
            }
        }
        catch let requestError as RequestError {
            throw RequestError.networkError(requestError)
        }
    }
    
    func create(createManagerDTO : CreateManagerDTO) async throws {
        do {
            let newManager = try await ManagerService.create(createManagerDTO: createManagerDTO)
            DispatchQueue.main.async {
                self.managerList.insert(ManagerViewModel(manager: newManager), at: 0)
            }
        }
        catch let requestError as RequestError {
            throw ManagerError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    
    subscript(index: Int) -> ManagerViewModel {
        return managerList[index]
    }
    
    // IteratorProtocol
    private var current: Int = 0
    
    /// Retourne le prochain élément dans la `gameList` tout en incrémentant l'index interne.
    /// - Precondition: `current` doit être inférieur au nombre d'éléments dans `gameList`.
    /// - Postcondition: L'index `current` est incrémenté.
    /// - Returns: L'élément de type `GameViewModel` à la position `current`, ou `nil` si la fin de la liste est atteinte.
    func next() -> ManagerViewModel? {
        guard current < self.managerList.count else { return nil }
        defer { current += 1 }
        return self.managerList[current]
    }
    
    // RandomAccessCollection
    var startIndex: Int { return managerList.startIndex }
    var endIndex: Int { return managerList.endIndex }
    
    /// Retourne l'index suivant à partir d'un index donné.
    /// - Parameter i: L'index actuel à partir duquel on veut obtenir l'index suivant.
    /// - Returns: L'index suivant dans `gameList` après `i`.
    func index(after i: Int) -> Int {
        return managerList.index(after: i)
    }
}
