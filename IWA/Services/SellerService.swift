//
//  SellerService.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//


enum SellerError: Error {
    case requestError(RequestError) // Réutiliser les erreurs de RequestError
    case noSellersFound
    case otherError(String)

    // Propriété pour obtenir un message d'erreur lisible
    var message: String {
        switch self {
        case .requestError(let requestError):
            // Réutiliser le message de RequestError
            return requestError.message
        case .noSellersFound:
            return "Il n'y a aucun vendeur."
        case .otherError(let message):
            return message
        }
    }
}

struct SellerService {
    
    static func getAllSellers() async throws -> [Seller] {
        let url = AppConfiguration.shared.apiURL + "/seller"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "GET", token: false)
            //print("📥 Réponse brute : \(data)")
            guard let sellerDTOs : [SellerDTO] = await JSONHelper.decode(data: data) else {
                throw SellerError.requestError(.invalidResponse)
            }
            let sellers = sellerDTOs.map { Seller(from: $0) }
            return sellers
        }
        catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw SellerError.noSellersFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw SellerError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    static func create(createSellerDTO : CreateSellerDTO) async throws -> Seller {
        let url = AppConfiguration.shared.apiURL + "/seller"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "POST", token: true, requestBody: createSellerDTO)
            guard let sellerDTO : SellerDTO = await JSONHelper.decode(data: data) else {
                throw SellerError.requestError(.invalidResponse)
            }
            let seller = Seller(from: sellerDTO)
            return seller
        }
        catch let requestError as RequestError {
            throw SellerError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func updateSellerById(sellerDTO : SellerDTO) async throws -> Seller {
        let url = AppConfiguration.shared.apiURL + "/seller/" + sellerDTO._id
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "PUT", token: true, requestBody: sellerDTO)
            guard let sellerDTO : SellerDTO = await JSONHelper.decode(data: data) else {
                throw SellerError.requestError(.invalidResponse)
            }
            let seller = Seller(from: sellerDTO)
            return seller
        }
        catch let requestError as RequestError {
            throw SellerError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func deleteSellerById(sellerId: String) async throws {
        let url = AppConfiguration.shared.apiURL + "/seller/" + sellerId
        
        do {
            let _ = try await RequestHelper.sendRequest(url: url, httpMethod: "DELETE", token: true)
        }
        catch let requestError as RequestError {
            throw SellerError.requestError(requestError) // Pass the caught RequestError
        }
    }
}

