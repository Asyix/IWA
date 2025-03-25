//
//  RefunService.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import Foundation

enum PaymentError: Error {
    case requestError(RequestError) // Réutiliser les erreurs de RequestError
    case noPaymentsFound
    case otherError(String)

    // Propriété pour obtenir un message d'erreur lisible
    var message: String {
        switch self {
        case .requestError(let requestError):
            // Réutiliser le message de RequestError
            return requestError.message
        case .noPaymentsFound:
            return "Il n'y a aucun paiement."
        case .otherError(let message):
            return message
        }
    }
}

struct PaymentService {
    
    static func getAllPayments() async throws -> [Payment] {
        let url = AppConfiguration.shared.apiURL + "/payment"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "GET", token: true)
            print("📥 Réponse brute : \(data)")
            guard let paymentDTOs : [PaymentDTO] = await JSONHelper.decode(data: data) else {
                throw PaymentError.requestError(.invalidResponse)
            }
            let payments = paymentDTOs.map { Payment(from: $0) }
            return payments
        }
        catch let requestError as RequestError {
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
    
    static func create(createPaymentDTO : CreatePaymentDTO) async throws -> Payment {
        let url = AppConfiguration.shared.apiURL + "/payment"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "POST", token: true, requestBody: createPaymentDTO)
            guard let paymentDTO : PaymentDTO = await JSONHelper.decode(data: data) else {
                throw PaymentError.requestError(.invalidResponse)
            }
            let payment = Payment(from: paymentDTO)
            return payment
        }
        catch let requestError as RequestError {
            throw PaymentError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func updatePaymentById(paymentDTO : PaymentDTO) async throws -> Payment {
        let url = AppConfiguration.shared.apiURL + "/payment/" + paymentDTO._id
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "PUT", token: true, requestBody: paymentDTO)
            guard let paymentDTO : PaymentDTO = await JSONHelper.decode(data: data) else {
                throw PaymentError.requestError(.invalidResponse)
            }
            let payment = Payment(from: paymentDTO)
            return payment
        }
        catch let requestError as RequestError {
            throw PaymentError.requestError(requestError) // Pass the caught RequestError
        }
    }
}

