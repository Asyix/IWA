//
//  JsonHelper.swift
//  IWA
//
//  Created by etud on 13/03/2025.
//

import Foundation
struct JSONHelper {
    func loadJson(filename: String, ext: String) -> Result<Data, JSONError>{ // Data si succès, JSONError sinon
      guard let fileURL = Bundle.main.url(forResource: filename, withExtension: ext) else { return .failure(.fileNotFound(filename+"."+ext)) }
      guard let content = try? Data(contentsOf: fileURL) else {
          return .failure(.JsonDecodingFailed)
      }
        return .success(content)
    }
    
    static func encode<T: Encodable>(data: T) async -> Data?{
        let encoder: JSONEncoder = JSONEncoder()
        return try? encoder.encode(data)
    }
    
    static func decode<T: Decodable>(data: Data) async -> T? {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        
        print("🔍 Début du décodage...")
        print("📦 Taille des données reçues: \(data.count) octets")
        
        do {
            let decoded: T = try decoder.decode(T.self, from: data)
            print("✅ Décodage réussi : \(decoded)")
            return decoded
        } catch {
            print("❌ Erreur de décodage : \(error.localizedDescription)")
            print("📜 Données en texte brut : \(String(data: data, encoding: .utf8) ?? "Données non lisibles")")
            return nil
        }
    }
    
    // Convertisseur ISO 8601
    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Supporte les millisecondes
        return formatter
    }()

}

