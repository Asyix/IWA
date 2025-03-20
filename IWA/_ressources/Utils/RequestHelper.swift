//
//  RequestHelper.swift
//  IWA
//
//  Created by etud on 17/03/2025.
//

import Foundation

import Foundation

enum RequestError: Error {
    case invalidURL
    case networkError(Error)
    case unauthorizedError
    case notFoundError
    case invalidResponse
    case invalidToken

    // Propriété pour obtenir un message d'erreur lisible
    var message: String {
        switch self {
        case .invalidURL:
            return "L'URL fournie est invalide."
        case .networkError(let error):
            return "Erreur réseau : \(error.localizedDescription)"
        case .unauthorizedError:
            return "Vous n'êtes pas autorisé à accéder à cette ressource."
        case .notFoundError:
            return "La ressource demandée est introuvable."
        case .invalidResponse:
            return "La réponse du serveur est invalide."
        case .invalidToken:
            return "Le token fourni est invalide."
        }
    }
}

struct RequestHelper {
    
    static func sendRequest<T: Encodable>(url : String, httpMethod: String, token: Bool, requestBody: T) async throws -> Data {
        guard let url = URL(string: url) else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token {
            guard let authToken = KeychainHelper.shared.getToken() else {
                throw RequestError.invalidToken
            }
            request.setValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = await JSONHelper.encode(data: requestBody)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RequestError.invalidResponse
            }
            print(httpResponse.statusCode)
            switch httpResponse.statusCode {
            case 201:
                // Succès : retourner les données et la réponse
                return data
            case 200:
                // Succès : retourner les données et la réponse
                return data
            case 401:
                throw RequestError.unauthorizedError
            case 404:
                throw RequestError.notFoundError
            default:
                // Gérer d'autres codes d'erreur si nécessaire
                throw RequestError.networkError(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil))
            }
        }
    }
    
    static func sendRequest(url : String, httpMethod: String, token: Bool) async throws -> Data {
        guard let url = URL(string: url) else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token {
            guard let authToken = KeychainHelper.shared.getToken() else {
                throw RequestError.invalidToken
            }
            request.setValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RequestError.invalidResponse
            }
            print(httpResponse.statusCode)
            switch httpResponse.statusCode {
            case 201:
                // Succès : retourner les données et la réponse
                return data
            case 200:
                // Succès : retourner les données et la réponse
                return data
            case 401:
                throw RequestError.unauthorizedError
            case 404:
                throw RequestError.notFoundError
            default:
                // Gérer d'autres codes d'erreur si nécessaire
                throw RequestError.networkError(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil))
            }
        }
    }
}


