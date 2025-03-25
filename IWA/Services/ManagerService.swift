//
//  ManagerService.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import Foundation


enum ManagerError: Error {
    case requestError(RequestError) // Réutiliser les erreurs de RequestError
    case noManagersFound
    case otherError(String)

    // Propriété pour obtenir un message d'erreur lisible
    var message: String {
        switch self {
        case .requestError(let requestError):
            // Réutiliser le message de RequestError
            return requestError.message
        case .noManagersFound:
            return "Il n'y a aucun vendeur."
        case .otherError(let message):
            return message
        }
    }
}

struct ManagerService {
    
    static func getAllManagers() async throws -> [Manager] {
        let url = AppConfiguration.shared.apiURL + "/manager"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "GET", token: true)
            //print("📥 Réponse brute : \(data)")
            guard let managerDTOs : [ManagerDTO] = await JSONHelper.decode(data: data) else {
                throw ManagerError.requestError(.invalidResponse)
            }
            let managers = managerDTOs.map { Manager(from: $0) }
            return managers
        }
        catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw ManagerError.noManagersFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw SellerError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    static func getProfile() async throws -> Manager {
        let url = AppConfiguration.shared.apiURL + "/manager/profile"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "GET", token: true)
            //print("📥 Réponse brute : \(data)")
            guard let managerDTO : ProfileDTO = await JSONHelper.decode(data: data) else {
                throw ManagerError.requestError(.invalidResponse)
            }
            let manager = Manager(from: managerDTO)
            return manager
        }
        catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw ManagerError.noManagersFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw SellerError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    static func create(createManagerDTO : CreateManagerDTO) async throws -> Manager {
        let url = AppConfiguration.shared.apiURL + "/manager/create"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "POST", token: true, requestBody: createManagerDTO)
            guard let managerDTO : ManagerDTO = await JSONHelper.decode(data: data) else {
                throw ManagerError.requestError(.invalidResponse)
            }
            let manager = Manager(from: managerDTO)
            return manager
        }
        catch let requestError as RequestError {
            throw ManagerError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func updateManagerById(managerDTO : ManagerDTO) async throws -> Manager {
        let url = AppConfiguration.shared.apiURL + "/manager/" + managerDTO.id
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "PUT", token: true, requestBody: managerDTO)
            guard let managerDTO : ManagerDTO = await JSONHelper.decode(data: data) else {
                throw ManagerError.requestError(.invalidResponse)
            }
            let manager = Manager(from: managerDTO)
            return manager
        }
        catch let requestError as RequestError {
            throw ManagerError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func deleteManagerById(managerId: String) async throws {
        let url = AppConfiguration.shared.apiURL + "/manager/" + managerId
        
        do {
            let _ = try await RequestHelper.sendRequest(url: url, httpMethod: "DELETE", token: true)
        }
        catch let requestError as RequestError {
            throw ManagerError.requestError(requestError) // Pass the caught RequestError
        }
    }
}

