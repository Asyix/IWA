//
//  PaymentViewModel.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

class PaymentViewModel: ObservableObject, Equatable, Hashable, Identifiable {
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Published var payment: Payment
    @Published var manager: Manager = Manager()
    @Published var seller: Seller = Seller()
    
    init(payment: Payment) {
        self.payment = payment
    }

    // Payment-specific properties
    var id: String { payment.id }
    
    var sellerId: String {
        get { payment.sellerId }
        set { payment.sellerId = newValue; objectWillChange.send() }
    }
    
    var sessionId: String {
        get { payment.sessionId }
        set { payment.sessionId = newValue; objectWillChange.send() }
    }
    
    var managerId: String {
        get { payment.managerId }
        set { payment.managerId = newValue; objectWillChange.send() }
    }
    
    var depositFeePayed: Double {
        get { payment.depositFeePayed }
        set { payment.depositFeePayed = newValue; objectWillChange.send() }
    }
    
    var depositDate: Date {
        get { payment.depositDate }
        set { payment.depositDate = newValue; objectWillChange.send() }
    }
    
    static func == (lhs: PaymentViewModel, rhs: PaymentViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Method to update the payment
    func updatePayment(paymentDTO: PaymentDTO) async throws {
        do {
            // Call your service to update the payment
            let updatedPayment = try await PaymentService.updatePaymentById(paymentDTO: paymentDTO)
            // Update the payment model
            DispatchQueue.main.async {
                if updatedPayment.id == self.id {
                    self.depositFeePayed = updatedPayment.depositFeePayed
                    self.depositDate = updatedPayment.depositDate
                    self.sellerId = updatedPayment.sellerId
                    self.sessionId = updatedPayment.sessionId
                    self.managerId = updatedPayment.managerId
                }
            }
        } catch let requestError as RequestError {
            throw PaymentError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    // Method to create a new payment
    func createPayment(paymentDTO: CreatePaymentDTO) async throws {
        do {
            // Call your service to create the payment
            let newPayment = try await PaymentService.create(createPaymentDTO: paymentDTO)
            // Update the payment model
            DispatchQueue.main.async {
                self.payment = newPayment
            }
        } catch let requestError as RequestError {
            throw PaymentError.requestError(requestError) // Pass the caught RequestError
        }
    }
}
