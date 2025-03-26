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
        apiURL = "http://crafiwabackend.cluster-ig4.igpolytech.fr"  // Local development server
        #else
        apiURL = "http://crafiwabackend.cluster-ig4.igpolytech.fr"
        #endif
    }
}
