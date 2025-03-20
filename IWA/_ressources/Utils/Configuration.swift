//
//  Configuration.swift
//  IWA
//
//  Created by etud on 15/03/2025.
//

import Foundation

class AppConfiguration {
    static let shared = AppConfiguration()
    
    let apiURL: String

    private init() {
        #if DEBUG
        apiURL = "http://localhost:5000"  // Local development server
        #else
        apiURL = "https://api.yourproductionurl.com"
        #endif
    }
}
