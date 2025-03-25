//
//  RefundListViewModel.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

class RefundListViewModel: ObservableObject {
    @Published var refundList: [RefundViewModel] = []
    @Published var sellerList: [Seller] = []
    
    func loadRefunds(sessionId: String) async throws {
        do {
            let fetchedRefunds = try await RefundService.getAllRefunds()
            DispatchQueue.main.async {
                if fetchedRefunds.isEmpty {
                    self.refundList = []
                }
                else
                {
                    self.refundList = fetchedRefunds.reversed().map { RefundViewModel(refund: $0) }
                    self.refundList = self.refundList.filter { $0.sessionId == sessionId }
                }
            }
        } catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw RefundError.noRefundsFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw RefundError.otherError(requestError.localizedDescription)
            }
            
        }
    }
    
    func loadRefundInfos(sessionId: String) async throws {
        do {
            let fetchedSellers = try await SellerService.getAllSellers()
            let fetchedManagers = try await ManagerService.getAllManagers()
            DispatchQueue.main.async {
                self.sellerList = fetchedSellers
                // Remise à zéro des compteurs
                // pour chaque refund
                for refund in self.refundList {
                    //trouver le vendeur correspondant
                    if let sellerIndex = fetchedSellers.firstIndex(where: { $0.id == refund.sellerId }) {
                        refund.seller = fetchedSellers[sellerIndex]
                        // trouver le manager correspondant
                        if let managerIndex = fetchedManagers.firstIndex(where: { $0.id == refund.managerId }) {
                            refund.manager = fetchedManagers[managerIndex]
                        }
                    }
                }
            }
        }
        catch let requestError as RequestError {
            throw RequestError.networkError(requestError)
        }
    }
    
    func create(createRefundDTO : CreateRefundDTO) async throws {
        do {
            let newRefund = try await RefundService.create(createRefundDTO: createRefundDTO)
            DispatchQueue.main.async {
                self.refundList.insert(RefundViewModel(refund: newRefund), at: 0)
            }
        }
        catch let requestError as RequestError {
            throw RefundError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    
    subscript(index: Int) -> RefundViewModel {
        return refundList[index]
    }
    
    // IteratorProtocol
    private var current: Int = 0
    
    /// Retourne le prochain élément dans la `gameList` tout en incrémentant l'index interne.
    /// - Precondition: `current` doit être inférieur au nombre d'éléments dans `gameList`.
    /// - Postcondition: L'index `current` est incrémenté.
    /// - Returns: L'élément de type `GameViewModel` à la position `current`, ou `nil` si la fin de la liste est atteinte.
    func next() -> RefundViewModel? {
        guard current < self.refundList.count else { return nil }
        defer { current += 1 }
        return self.refundList[current]
    }
    
    // RandomAccessCollection
    var startIndex: Int { return refundList.startIndex }
    var endIndex: Int { return refundList.endIndex }
    
    /// Retourne l'index suivant à partir d'un index donné.
    /// - Parameter i: L'index actuel à partir duquel on veut obtenir l'index suivant.
    /// - Returns: L'index suivant dans `gameList` après `i`.
    func index(after i: Int) -> Int {
        return refundList.index(after: i)
    }
}
