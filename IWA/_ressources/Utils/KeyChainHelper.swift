//
//  KeyChainHelper.swift
//  IWA
//
//  Created by etud on 15/03/2025.
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    
    private init() {}

    // 🔹 Save token in Keychain
    func saveToken(_ token: String, service: String = "com.yourapp.auth", account: String = "userToken") {
        let data = Data(token.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // Remove existing item if it exists
        SecItemAdd(query as CFDictionary, nil)
    }

    // 🔹 Retrieve token from Keychain
    func getToken(service: String = "com.yourapp.auth", account: String = "userToken") -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        if let data = result as? Data {
            return String(decoding: data, as: UTF8.self)
        }
        return nil
    }

    // 🔹 Delete token from Keychain (Logout)
    func deleteToken(service: String = "com.yourapp.auth", account: String = "userToken") {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }

    // 🔹 Check if a token exists in Keychain
    func hasToken(service: String = "com.yourapp.auth", account: String = "userToken") -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: false, // We don't need the actual data
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}
