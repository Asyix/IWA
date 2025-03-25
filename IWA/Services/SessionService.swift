//
//  SessionService.swift
//  IWA
//
//  Created by etud on 18/03/2025.
//

enum SessionError: Error {
    case requestError(RequestError) // Réutiliser les erreurs de RequestError
    case noSessionsFound
    case otherError(String)

    // Propriété pour obtenir un message d'erreur lisible
    var message: String {
        switch self {
        case .requestError(let requestError):
            // Réutiliser le message de RequestError
            return requestError.message
        case .noSessionsFound:
            return "Il n'y a aucune session."
        case .otherError(let message):
            return message
        }
    }
}

struct SessionService {
    
    static func getAllSessions() async throws -> [Session] {
        let url = AppConfiguration.shared.apiURL + "/session"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "GET", token: false)
            //print("📥 Réponse brute : \(data)")
            guard let sessionsDTOs : [SessionDTO] = await JSONHelper.decode(data: data) else {
                throw SessionError.requestError(.invalidResponse)
            }
            let sessions = sessionsDTOs.map { Session(from: $0) }
            return sessions
        }
        catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw SessionError.noSessionsFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw SessionError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    static func create(createSessionDto : CreateSessionDTO) async throws -> Session {
        let url = AppConfiguration.shared.apiURL + "/session"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "POST", token: true, requestBody: createSessionDto)
            guard let sessionDTO : SessionDTO = await JSONHelper.decode(data: data) else {
                throw SessionError.requestError(.invalidResponse)
            }
            let session = Session(from: sessionDTO)
            return session
        }
        catch let requestError as RequestError {
            throw SessionError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func updateSessionById(updateSessionDto : UpdateSessionDTO) async throws -> Session {
        let url = AppConfiguration.shared.apiURL + "/session/" + updateSessionDto.id
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "PUT", token: true, requestBody: updateSessionDto)
            guard let sessionDto : SessionDTO = await JSONHelper.decode(data: data) else {
                throw SessionError.requestError(.invalidResponse)
            }
            let session = Session(from: sessionDto)
            return session
        }
        catch let requestError as RequestError {
            throw SessionError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func deleteSessionById(session: Session) async throws {
        let url = AppConfiguration.shared.apiURL + "/session/" + session.id
        
        do {
            let _ = try await RequestHelper.sendRequest(url: url, httpMethod: "DELETE", token: true)
        }
        catch let requestError as RequestError {
            throw SessionError.requestError(requestError) // Pass the caught RequestError
        }
    }
}
