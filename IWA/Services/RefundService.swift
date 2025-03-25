//
//  RefunService.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import Foundation

enum RefundError: Error {
    case requestError(RequestError) // Réutiliser les erreurs de RequestError
    case noRefundsFound
    case otherError(String)

    // Propriété pour obtenir un message d'erreur lisible
    var message: String {
        switch self {
        case .requestError(let requestError):
            // Réutiliser le message de RequestError
            return requestError.message
        case .noRefundsFound:
            return "Il n'y a aucun vendeur."
        case .otherError(let message):
            return message
        }
    }
}

struct RefundService {
    
    static func getAllRefunds() async throws -> [Refund] {
        let url = AppConfiguration.shared.apiURL + "/refund/all"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "GET", token: true)
            //print("📥 Réponse brute : \(data)")
            guard let refundDTOs : [RefundDTO] = await JSONHelper.decode(data: data) else {
                throw RefundError.requestError(.invalidResponse)
            }
            let refunds = refundDTOs.map { Refund(from: $0) }
            return refunds
        }
        catch let requestError as RequestError {
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
    
    static func create(createRefundDTO : CreateRefundDTO) async throws -> Refund {
        let url = AppConfiguration.shared.apiURL + "/refund"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "POST", token: true, requestBody: createRefundDTO)
            guard let refundDTO : RefundDTO = await JSONHelper.decode(data: data) else {
                throw RefundError.requestError(.invalidResponse)
            }
            let refund = Refund(from: refundDTO)
            return refund
        }
        catch let requestError as RequestError {
            throw RefundError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func updateRefundById(refundDTO : RefundDTO) async throws -> Refund {
        let url = AppConfiguration.shared.apiURL + "/refund/" + refundDTO._id
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "PUT", token: true, requestBody: refundDTO)
            guard let refundDTO : RefundDTO = await JSONHelper.decode(data: data) else {
                throw RefundError.requestError(.invalidResponse)
            }
            let refund = Refund(from: refundDTO)
            return refund
        }
        catch let requestError as RequestError {
            throw RefundError.requestError(requestError) // Pass the caught RequestError
        }
    }
}

