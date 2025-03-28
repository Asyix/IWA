//
//  Session.swift
//  IWA
//
//  Created by etud on 19/03/2025.
//

import Foundation

class Session: ObservableObject, Hashable {
    private(set) var id: String
    @Published var name: String
    @Published var location: String
    @Published var description: String?
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var depositFee: Double
    @Published var depositFeeLimitBeforeDiscount: Double
    @Published var depositFeeDiscount: Double
    @Published var saleComission: Double
    @Published var managerId: String
    
    init(from dto: SessionDTO) {
        self.id = dto._id
        self.name = dto.name
        self.location = dto.location
        self.description = dto.description
        self.depositFee = dto.depositFee
        self.depositFeeLimitBeforeDiscount = dto.depositFeeLimitBeforeDiscount
        self.depositFeeDiscount = dto.depositFeeDiscount
        self.saleComission = dto.saleComission
        self.managerId = dto.managerId

        // Conversion des dates
        self.startDate = JSONHelper.dateFormatter.date(from: dto.startDate) ?? Date()
        self.endDate = JSONHelper.dateFormatter.date(from: dto.endDate) ?? Date()
        
    }
    
    static func == (lhs: Session, rhs: Session) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct SessionDTO: Codable {
    var _id: String  // L'ID est généré par la base
    var name: String
    var location: String
    var description: String?
    var startDate: String
    var endDate: String
    var depositFee: Double
    var depositFeeLimitBeforeDiscount: Double
    var depositFeeDiscount: Double
    var saleComission: Double
    var managerId: String
}

struct CreateSessionDTO: Codable {
    var name: String
    var location: String
    var description: String?
    var startDate: String
    var endDate: String
    var depositFee: Double
    var depositFeeLimitBeforeDiscount: Double
    var depositFeeDiscount: Double
    var saleComission: Double
}

struct UpdateSessionDTO : Codable {
    var id: String
    var name: String
    var location: String
    var description: String?
    var startDate: Date
    var endDate: Date
    var depositFee: Double
    var depositFeeLimitBeforeDiscount: Double
    var depositFeeDiscount: Double
    var saleComission: Double
}

