//
//  env.swift
//  IWA
//
//  Created by etud on 15/03/2025.
//

import SwiftUI

struct ApiUrl : EnvironmentKey {
    static let defaultValue: String = "http://localhost:5000"
}

extension EnvironmentValues {
    var apiURL : String {
        get {self[ApiUrl.self]}
        set {self[ApiUrl.self] = newValue}
    }
}
