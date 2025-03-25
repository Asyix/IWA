//
//  DepositListViewModel.swift
//  IWA
//
//  Created by etud on 24/03/2025.
//

import SwiftUI


class DepositListViewModel: ObservableObject {
    @Published var depositList: [DepositViewModel] = []
    @Published var gameList: [Game] = []
    @Published var sellerList: [Seller] = []
    
    
    func loadDeposits(sessionId: String) async throws {
        do {
            let fetchedDepositedGames = try await DepositedGameService.getAllDepositedGames(sessionId: sessionId)
            let fetchedSellers = try await SellerService.getAllSellers()
            let fetchedGames = try await GameService.getAllGames()
            
            DispatchQueue.main.async {
                if fetchedDepositedGames.isEmpty {
                    self.depositList = []
                }
                else
                {
                    self.depositList = fetchedDepositedGames.reversed().map { DepositViewModel(depositedGame: $0) }
                }
                self.sellerList = fetchedSellers.sorted(by: { $0.name < $1.name })
                self.gameList = fetchedGames.sorted(by: { $0.name < $1.name })
                // Comptage des jeux en vente
                for deposit in self.depositList {
                    //trouver le jeu correspondant
                    if let index = fetchedGames.firstIndex(where: { $0.id == deposit.gameId  }) {
                        deposit.name = fetchedGames[index].name
                        deposit.photoURL = fetchedGames[index].photoURL
                    }
                    if let index = fetchedSellers.firstIndex(where: { $0.id == deposit.sellerId }) {
                        deposit.seller = fetchedSellers[index]
                    }
                }
            }
        }
        catch let requestError as RequestError {
            throw RequestError.networkError(requestError)
        }
    }
    
    func create(createDepositDTO : CreateDepositedGameDTO) async throws {
        do {
            let newDeposit = try await DepositedGameService.create(createDepositedGameDTO: createDepositDTO)
            DispatchQueue.main.async {
                self.depositList.insert(DepositViewModel(depositedGame: newDeposit), at: 0)
            }
        }
        catch let requestError as RequestError {
            throw DepositedGameError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    
    subscript(index: Int) -> DepositViewModel {
        return depositList[index]
    }
    
    // IteratorProtocol
    private var current: Int = 0
    
    /// Retourne le prochain élément dans la `transactionList` tout en incrémentant l'index interne.
    /// - Precondition: `current` doit être inférieur au nombre d'éléments dans `transactionList`.
    /// - Postcondition: L'index `current` est incrémenté.
    /// - Returns: L'élément de type `TransactionViewModel` à la position `current`, ou `nil` si la fin de la liste est atteinte.
    func next() -> DepositViewModel? {
        guard current < self.depositList.count else { return nil }
        defer { current += 1 }
        return self.depositList[current]
    }
    
    // RandomAccessCollection
    var startIndex: Int { return depositList.startIndex }
    var endIndex: Int { return depositList.endIndex }
    
    /// Retourne l'index suivant à partir d'un index donné.
    /// - Parameter i: L'index actuel à partir duquel on veut obtenir l'index suivant.
    /// - Returns: L'index suivant dans `transactionList` après `i`.
    func index(after i: Int) -> Int {
        return depositList.index(after: i)
    }
}
