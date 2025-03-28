import Foundation

// Refund Model
class Payment: ObservableObject, Hashable {
    private(set) var id: String
    @Published var sellerId: String
    @Published var sessionId: String
    @Published var managerId: String
    @Published var depositFeePayed: Double
    @Published var depositDate: Date

    // Initializer from RefundDTO
    init(from dto: PaymentDTO) {
        self.id = dto._id
        self.sellerId = dto.sellerId
        self.sessionId = dto.sessionId
        self.managerId = dto.managerId
        self.depositFeePayed = dto.depositFeePayed
        self.depositDate = JSONHelper.dateFormatter.date(from: dto.depositDate) ?? Date()
    }
    
    static func == (lhs: Payment, rhs: Payment) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// DTO for Payment
struct PaymentDTO: Codable {
    var _id: String  // The ID is generated by the backend
    var sellerId: String
    var sessionId: String
    var managerId: String
    var depositFeePayed: Double
    var depositDate: String  // The date as a string, to be converted
}

// CreatePayment - for creating a payment
struct CreatePaymentDTO: Codable {
    var sellerId: String
    var sessionId: String
    var depositFeePayed: Double
    var depositDate: String  // Date should be a string in the required format
}

// UpdatePaymentDTO - for updating an existing payment
struct UpdatePaymentDTO: Codable {
    var id: String
    var sellerId: String
    var sessionId: String
    var managerId: String
    var depositFeePayed: Double
    var depositDate: Date  // Date for update should be in Date format
}

