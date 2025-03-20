//
//  AuthService.swift
//  IWA
//
//  Created by etud on 17/03/2025.
//

import Foundation

enum LoginError: Error {
    case requestError(RequestError) // Réutiliser les erreurs de RequestError
    case invalidCredentials // Cas personnalisé pour les identifiants invalides

    // Propriété pour obtenir un message d'erreur lisible
    var message: String {
        switch self {
        case .requestError(let requestError):
            // Réutiliser le message de RequestError
            return requestError.message
        case .invalidCredentials:
            // Message personnalisé pour les identifiants invalides
            return "Mauvais email et/ou mot de passe"
        }
    }
}

struct LoginResponse: Decodable {
    var token: String
}

struct LoginService {
    static func login(email: String, password: String) async throws {
        let url : String = AppConfiguration.shared.apiURL + "/auth/login"
        let body : LoginDTO = LoginDTO(email: email, password: password)
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "POST", token: false, requestBody: body)
            if let decoded: LoginResponse = await JSONHelper.decode(data: data) {
                DispatchQueue.main.async {
                    KeychainHelper.shared.saveToken(decoded.token)
                    AuthManager.shared.isAuthenticated = true
                }
            }
        }
        catch let requestError as RequestError {
            print(requestError)
            // Transformer RequestError en LoginError
            switch requestError {
            case .unauthorizedError:
                // Personnaliser le message pour les identifiants invalides
                throw LoginError.invalidCredentials
            default:
                // Réutiliser les autres erreurs de RequestError
                throw LoginError.requestError(requestError)
            }
        }
    }
}

