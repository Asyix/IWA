//
//  RefundViewModel.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

class RefundViewModel: ObservableObject, Equatable, Hashable, Identifiable {
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Published var refund: Refund
    @Published var manager: Manager = Manager()
    @Published var seller: Seller = Seller()
    
    init(refund: Refund) {
        self.refund = refund
    }

    // Refund-specific properties
    var id: String { refund.id }
    
    var sellerId: String {
        get { refund.sellerId }
        set { refund.sellerId = newValue; objectWillChange.send() }
    }
    
    var sessionId: String {
        get { refund.sessionId }
        set { refund.sessionId = newValue; objectWillChange.send() }
    }
    
    var managerId: String {
        get { refund.managerId }
        set { refund.managerId = newValue; objectWillChange.send() }
    }
    
    var refundAmount: Double {
        get { refund.refundAmount }
        set { refund.refundAmount = newValue; objectWillChange.send() }
    }
    
    var depositDate: Date {
        get { refund.depositDate }
        set { refund.depositDate = newValue; objectWillChange.send() }
    }
    
    static func == (lhs: RefundViewModel, rhs: RefundViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Method to update the refund
    func updateRefund(refundDTO: RefundDTO) async throws {
        do {
            // Call your service to update the refund
            let updatedRefund = try await RefundService.updateRefundById(refundDTO: refundDTO)
            // Update the refund model
            DispatchQueue.main.async {
                if updatedRefund.id == self.id {
                    self.refundAmount = updatedRefund.refundAmount
                    self.depositDate = updatedRefund.depositDate
                    self.sellerId = updatedRefund.sellerId
                    self.sessionId = updatedRefund.sessionId
                    self.managerId = updatedRefund.managerId
                }
            }
        } catch let requestError as RequestError {
            throw RefundError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    // Method to create a new refund
    func createRefund(refundDTO: CreateRefundDTO) async throws {
        do {
            // Call your service to create the refund
            let newRefund = try await RefundService.create(createRefundDTO: refundDTO)
            // Update the refund model
            DispatchQueue.main.async {
                self.refund = newRefund
            }
        } catch let requestError as RequestError {
            throw RefundError.requestError(requestError) // Pass the caught RequestError
        }
    }
}
