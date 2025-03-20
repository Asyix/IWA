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
    
    static func decode<T: Decodable>(data: Data) async -> T?{
        let decoder: JSONDecoder = JSONDecoder()
        guard let decoded: T = try? decoder.decode(T.self, from: data) else {
            return nil
        }
        return decoded
    }
}

