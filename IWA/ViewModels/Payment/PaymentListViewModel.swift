//
//  PaymentListViewModel.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

class PaymentListViewModel: ObservableObject {
    @Published var paymentList: [PaymentViewModel] = []
    @Published var sellerList: [Seller] = []
    
    func loadPayments(sessionId: String) async throws {
        do {
            let fetchedPayments = try await PaymentService.getAllPayments()
            DispatchQueue.main.async {
                if fetchedPayments.isEmpty {
                    self.paymentList = []
                }
                else
                {
                    self.paymentList = fetchedPayments.reversed().map { PaymentViewModel(payment: $0) }
                    self.paymentList = self.paymentList.filter { $0.sessionId == sessionId }
                }
            }
        } catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw PaymentError.noPaymentsFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw PaymentError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    func loadPaymentInfos(sessionId: String) async throws {
        do {
            let fetchedSellers = try await SellerService.getAllSellers()
            let fetchedManagers = try await ManagerService.getAllManagers()
            DispatchQueue.main.async {
                self.sellerList = fetchedSellers
                // Remise à zéro des compteurs
                for index in self.paymentList.indices {
                    self.paymentList[index].seller = Seller()
                    self.paymentList[index].manager = Manager()
                }
                // pour chaque payment
                for payment in self.paymentList {
                    //trouver le vendeur correspondant
                    if let sellerIndex = fetchedSellers.firstIndex(where: { $0.id == payment.sellerId }) {
                        payment.seller = fetchedSellers[sellerIndex]
                        // trouver le manager correspondant
                        if let managerIndex = fetchedManagers.firstIndex(where: { $0.id == payment.managerId }) {
                            payment.manager = fetchedManagers[managerIndex]
                        }
                    }
                }
            }
        }
        catch let requestError as RequestError {
            throw RequestError.networkError(requestError)
        }
    }
    
    func create(createPaymentDTO : CreatePaymentDTO) async throws {
        do {
            let newPayment = try await PaymentService.create(createPaymentDTO: createPaymentDTO)
            DispatchQueue.main.async {
                self.paymentList.insert(PaymentViewModel(payment: newPayment), at: 0)
            }
        }
        catch let requestError as RequestError {
            throw PaymentError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    
    subscript(index: Int) -> PaymentViewModel {
        return paymentList[index]
    }
    
    // IteratorProtocol
    private var current: Int = 0
    
    /// Retourne le prochain élément dans la `gameList` tout en incrémentant l'index interne.
    /// - Precondition: `current` doit être inférieur au nombre d'éléments dans `gameList`.
    /// - Postcondition: L'index `current` est incrémenté.
    /// - Returns: L'élément de type `GameViewModel` à la position `current`, ou `nil` si la fin de la liste est atteinte.
    func next() -> PaymentViewModel? {
        guard current < self.paymentList.count else { return nil }
        defer { current += 1 }
        return self.paymentList[current]
    }
    
    // RandomAccessCollection
    var startIndex: Int { return paymentList.startIndex }
    var endIndex: Int { return paymentList.endIndex }
    
    /// Retourne l'index suivant à partir d'un index donné.
    /// - Parameter i: L'index actuel à partir duquel on veut obtenir l'index suivant.
    /// - Returns: L'index suivant dans `gameList` après `i`.
    func index(after i: Int) -> Int {
        return paymentList.index(after: i)
    }
}
