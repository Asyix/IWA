//
//  User.swift
//  IWA
//
//  Created by etud on 15/03/2025.
//

import Foundation

class Manager : ObservableObject {
    private(set) var id: String
    private(set) var email: String
    private(set) var admin: Bool
    private(set) var address: String
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var phone: String
    
    init(id: String, email: String, admin: Bool, address: String, firstName: String, lastName: String, phone: String) {
        self.id = id
        self.email = email
        self.admin = admin
        self.address = address
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
}

struct LoginDTO : Codable, Hashable {
    var email: String
    var password: String
}
