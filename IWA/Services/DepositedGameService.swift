//
//  DepositedGameService.swift
//  IWA
//
//  Created by etud on 21/03/2025.
//

import Foundation
import SwiftUI

enum DepositedGameError: Error {
    case requestError(RequestError) // Réutiliser les erreurs de RequestError
    case noDepositedGamesFound
    case otherError(String)

    // Propriété pour obtenir un message d'erreur lisible
    var message: String {
        switch self {
        case .requestError(let requestError):
            // Réutiliser le message de RequestError
            return requestError.message
        case .noDepositedGamesFound:
            return "Il n'y a aucun jeu déposé."
        case .otherError(let message):
            return message
        }
    }
}

struct DepositedGameService {
        
    static func getAllDepositedGames(sessionId: String) async throws -> [DepositedGame] {
        let url = AppConfiguration.shared.apiURL + "/depositedGame/session/" + sessionId
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "GET", token: false)
            print("📥 Réponse brute : \(data)")
            guard let depositedGameDTOS : [DepositedGameDTO] = await JSONHelper.decode(data: data) else {
                throw DepositedGameError.requestError(.invalidResponse)
            }
            let depositedGames = depositedGameDTOS.map { DepositedGame(from: $0) }
            return depositedGames
        }
        catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw DepositedGameError.noDepositedGamesFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw DepositedGameError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    
    static func updateGameById(depositedGameDTO : DepositedGameDTO) async throws -> DepositedGame {
        let url = AppConfiguration.shared.apiURL + "/depositedGame/" + depositedGameDTO._id
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "PUT", token: true, requestBody: depositedGameDTO)
            guard let updatedGameDTO : DepositedGameDTO = await JSONHelper.decode(data: data) else {
                throw DepositedGameError.requestError(.invalidResponse)
            }
            let game = DepositedGame(from: updatedGameDTO)
            return game
        }
        catch let requestError as RequestError {
            throw DepositedGameError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func create(createDepositedGameDTO : CreateDepositedGameDTO) async throws -> DepositedGame {
        let url = AppConfiguration.shared.apiURL + "/depositedGame"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "POST", token: true, requestBody: createDepositedGameDTO)
            guard let gameDTO : DepositedGameDTO = await JSONHelper.decode(data: data) else {
                throw DepositedGameError.requestError(.invalidResponse)
            }
            let game = DepositedGame(from: gameDTO)
            return game
        }
        catch let requestError as RequestError {
            throw DepositedGameError.requestError(requestError) // Pass the caught RequestError
        }
    }
}

