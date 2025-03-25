//
//  Client.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import Foundation

class Client: ObservableObject, Hashable {
    private(set) var id: String
    @Published var name: String
    @Published var email: String
    @Published var phone: String
    @Published var address: String
    @Published var amountSpent: Double = 0
    @Published var sellerTransactions: [SellerTransaction] = []
    
    init(from dto: ClientDTO) {
        self.id = dto._id
        self.name = dto.name
        self.email = dto.email
        self.phone = dto.phone
        self.address = dto.address
    }
    
    init() {
        self.id = "0"
        self.name = ""
        self.email = ""
        self.address = ""
        self.phone = ""
    }
    
    
    static func == (lhs: Client, rhs: Client) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ClientDTO: Codable {
    var _id: String  // L'ID est généré par la base
    var name: String
    var email: String
    var phone: String
    var address: String
}

struct CreateClientDTO: Codable {
    var name: String
    var email: String
    var address: String
    var phone: String
}
    


