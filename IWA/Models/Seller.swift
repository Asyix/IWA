//
//  Seller.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import Foundation

class Seller: ObservableObject, Hashable, Identifiable {
    private(set) var id: String
    @Published var name: String
    @Published var email: String
    @Published var phone: String
    @Published var amountOwed: Double
    
    init(from dto: SellerDTO) {
        self.id = dto._id
        self.name = dto.name
        self.email = dto.email
        self.phone = dto.phone
        self.amountOwed = dto.amountOwed
    }
    
    init() {
        self.id = "0"
        self.name = ""
        self.email = ""
        self.phone = ""
        self.amountOwed = 0
    }
    
    
    static func == (lhs: Seller, rhs: Seller) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SellerDTO: Codable {
    var _id: String  // L'ID est généré par la base
    var name: String
    var email: String
    var phone: String
    var amountOwed: Double
}

struct CreateSellerDTO: Codable {
    var name: String
    var email: String
    var phone: String
    var amountOwed: Double = 0
}
    

