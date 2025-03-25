//
//  TransactionService.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

enum TransactionError: Error {
    case requestError(RequestError) // Réutiliser les erreurs de RequestError
    case noTransactionsFound
    case otherError(String)

    // Propriété pour obtenir un message d'erreur lisible
    var message: String {
        switch self {
        case .requestError(let requestError):
            // Réutiliser le message de RequestError
            return requestError.message
        case .noTransactionsFound:
            return "Il n'y a aucune transaction."
        case .otherError(let message):
            return message
        }
    }
}

struct TransactionService {
    
    static func getAllTransactions(sessionId : String) async throws -> [Transaction] {
        let url = AppConfiguration.shared.apiURL + "/transaction/by-session/" + sessionId
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "GET", token: false)
            //print("📥 Réponse brute : \(data)")
            guard let transactionDTOs : [TransactionDTO] = await JSONHelper.decode(data: data) else {
                throw TransactionError.requestError(.invalidResponse)
            }
            let transactions = transactionDTOs.map { Transaction(from: $0) }
            return transactions
        }
        catch let requestError as RequestError {
            // Transformer RequestError en LoginError
            switch requestError {
            case .notFoundError:
                // Personnaliser le message pour les identifiants invalides
                throw TransactionError.noTransactionsFound
            default:
                // Réutiliser les autres erreurs de RequestError
                throw TransactionError.otherError(requestError.localizedDescription)
            }
        }
    }
    
    static func create(createTransactionDTO : CreateTransactionDTO) async throws -> Transaction {
        let url = AppConfiguration.shared.apiURL + "/transaction"
        
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "POST", token: true, requestBody: createTransactionDTO)
            guard let transactionDTO : TransactionDTO = await JSONHelper.decode(data: data) else {
                throw TransactionError.requestError(.invalidResponse)
            }
            let transaction = Transaction(from: transactionDTO)
            return transaction
        }
        catch let requestError as RequestError {
            throw TransactionError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func updateTransactionById(updateTransactionDTO : UpdateTransactionDTO) async throws -> Transaction {
        let url = AppConfiguration.shared.apiURL + "/transaction/" + updateTransactionDTO._id
        do {
            let data = try await RequestHelper.sendRequest(url: url, httpMethod: "PUT", token: true, requestBody: updateTransactionDTO)
            guard let transactionDTO : TransactionDTO = await JSONHelper.decode(data: data) else {
                throw TransactionError.requestError(.invalidResponse)
            }
            let transaction = Transaction(from: transactionDTO)
            return transaction
        }
        catch let requestError as RequestError {
            throw TransactionError.requestError(requestError) // Pass the caught RequestError
        }
    }
    
    static func deleteSessionById(transactionId: String) async throws {
        let url = AppConfiguration.shared.apiURL + "/transaction/" + transactionId
        
        do {
            let _ = try await RequestHelper.sendRequest(url: url, httpMethod: "DELETE", token: true)
        }
        catch let requestError as RequestError {
            throw TransactionError.requestError(requestError) // Pass the caught RequestError
        }
    }
}

