//
//  User.swift
//  IWA
//
//  Created by etud on 15/03/2025.
//

import Foundation

class Manager: ObservableObject, Identifiable, Hashable {
    private(set) var id: String
    @Published var email: String
    @Published var admin: Bool
    @Published var firstName: String
    @Published var lastName: String
    @Published var phone: String
    @Published var address: String
    
    init(from dto: ManagerDTO) {
        self.id = dto._id
        self.firstName = dto.firstName
        self.lastName = dto.lastName
        self.email = dto.email
        self.phone = dto.phone
        self.address = dto.address
        self.admin = dto.admin
    }
    
    init() {
        self.id = "0"
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.phone = ""
        self.address = ""
        self.admin = false
    }
    
    static func == (lhs: Manager, rhs: Manager) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ManagerDTO: Codable {
    var _id: String  // L'ID est généré par la base
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var address: String
    var admin: Bool
}

struct CreateManagerDTO: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var address: String
    var admin: Bool = false
    var password: String
}

struct LoginDTO: Codable, Hashable {
    var email: String
    var password: String
}


