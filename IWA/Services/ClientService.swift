//
//  ClientService.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

enum ClientError: Error {
    case requestError(RequestError) // Réutiliser les erreurs de RequestError
    case noClientsFound
    case otherError(String)

    // Propriété pour obtenir un message d'erreur lisible
    var message: String {
        switch self {
        case .requestError(let requestError):
            // Réutiliser le message de RequestError
            return requestError.message
        case .noClientsFound:
            return "Il n'y a aucun client."
        case .otherError(let message):
            return message
        }
    }
}

struct ClientService {
    
    static func getAllClients() async throws -> [Client] {
        let url = AppConfiguration.shared.apiURL + "/client"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "GET", token: false)
            print("📥 Réponse brute : \(data)")
            guard let clientDTOs : [ClientDTO] = await JSONHelper.decode(data: data) else {
                throw ClientError.requestError(.invalidResponse)
            }
            let clients = clientDTOs.map { Client(from: $0) }
            return clients
        }
        catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw ClientError.noClientsFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw ClientError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    static func create(createClientDTO : CreateClientDTO) async throws -> Client {
        let url = AppConfiguration.shared.apiURL + "/client"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "POST", token: true, requestBody: createClientDTO)
            guard let clientDTO : ClientDTO = await JSONHelper.decode(data: data) else {
                throw ClientError.requestError(.invalidResponse)
            }
            let client = Client(from: clientDTO)
            return client
        }
        catch let requestError as RequestError {
            throw ClientError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func updateClientById(clientDTO : ClientDTO) async throws -> Client {
        let url = AppConfiguration.shared.apiURL + "/client/" + clientDTO._id
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "PUT", token: true, requestBody: clientDTO)
            guard let clientDTO : ClientDTO = await JSONHelper.decode(data: data) else {
                throw ClientError.requestError(.invalidResponse)
            }
            let client = Client(from: clientDTO)
            return client
        }
        catch let requestError as RequestError {
            throw ClientError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func deleteClientById(clientId: String) async throws {
        let url = AppConfiguration.shared.apiURL + "/client/" + clientId
        
        do {
            let _ = try await RequestHelper.sendRequest(url: url, httpMethod: "DELETE", token: true)
        }
        catch let requestError as RequestError {
            throw ClientError.requestError(requestError) // Pass the caught RequestError
        }
    }
}


