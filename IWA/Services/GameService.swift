//
//  GameService.swift
//  IWA
//
//  Created by etud on 21/03/2025.
//

enum GameError: Error {
    case requestError(RequestError) // Réutiliser les erreurs de RequestError
    case noGamesFound
    case otherError(String)

    // Propriété pour obtenir un message d'erreur lisible
    var message: String {
        switch self {
        case .requestError(let requestError):
            // Réutiliser le message de RequestError
            return requestError.message
        case .noGamesFound:
            return "Il n'y a aucun jeu."
        case .otherError(let message):
            return message
        }
    }
}

struct GameService {
    
    static func getAllGames() async throws -> [Game] {
        let url = AppConfiguration.shared.apiURL + "/gameDescription"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "GET", token: false)
            //print("📥 Réponse brute : \(data)")
            guard let gameDTOS : [GameDTO] = await JSONHelper.decode(data: data) else {
                throw GameError.requestError(.invalidResponse)
            }
            let games = gameDTOS.map { Game(from: $0) }
            return games
        }
        catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw GameError.noGamesFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw GameError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    static func create(createGameDTO : CreateGameDTO) async throws -> Game {
        let url = AppConfiguration.shared.apiURL + "/gameDescription"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "POST", token: true, requestBody: createGameDTO)
            guard let gameDTO : GameDTO = await JSONHelper.decode(data: data) else {
                throw GameError.requestError(.invalidResponse)
            }
            let game = Game(from: gameDTO)
            return game
        }
        catch let requestError as RequestError {
            throw GameError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func updateGameById(gameDTO : GameDTO) async throws -> Game {
        let url = AppConfiguration.shared.apiURL + "/gameDescription/" + gameDTO._id
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "PUT", token: true, requestBody: gameDTO)
            guard let updatedGameDTO : GameDTO = await JSONHelper.decode(data: data) else {
                throw GameError.requestError(.invalidResponse)
            }
            let game = Game(from: updatedGameDTO)
            return game
        }
        catch let requestError as RequestError {
            throw GameError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func deleteSessionById(id: String) async throws {
        let url = AppConfiguration.shared.apiURL + "/gameDescription/" + id
        
        do {
            let _ = try await RequestHelper.sendRequest(url: url, httpMethod: "DELETE", token: true)
        }
        catch let requestError as RequestError {
            throw GameError.requestError(requestError) // Pass the caught RequestError
        }
    }
}
