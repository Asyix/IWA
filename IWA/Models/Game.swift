//
//  Game.swift
//  IWA
//
//  Created by etud on 21/03/2025.
//

import Foundation

enum AgeRange: String, Codable, CaseIterable, Identifiable {
    case VeryYoung = "0-5"
    case Child = "5-10"
    case Preteen = "8-12"
    case Teen = "12-18"
    case Pegi3 = "3+"
    case Pegi7 = "7+"
    case Pegi12 = "12+"
    case Pegi16 = "16+"
    case Adult = "18+"
    
    var id: String { self.rawValue }
    
    var isPegi: Bool {
        switch self {
        case .Pegi3, .Pegi7, .Pegi12, .Pegi16, .Adult:
            return true
        default:
            return false
        }
    }
}


class Game: ObservableObject, Hashable, Identifiable {
    private(set) var id: String
    @Published var name: String
    @Published var publisher: String
    @Published var description: String
    @Published var photoURL: URL?
    @Published var minPlayers: Int
    @Published var maxPlayers: Int
    @Published var ageRange: AgeRange
    
    init(from dto: GameDTO) {
        self.id = dto._id
        self.name = dto.name
        self.publisher = dto.publisher
        self.description = dto.description
        self.photoURL = dto.photoURL.isEmpty ? nil : URL(string: dto.photoURL)
        self.minPlayers = dto.minPlayers
        self.maxPlayers = dto.maxPlayers
        self.ageRange = AgeRange(rawValue: dto.ageRange) ?? .Pegi3
    }
    
    init() {
        self.id = "0"
        self.name = ""
        self.publisher = ""
        self.description = ""
        self.photoURL = nil
        self.minPlayers = 0
        self.maxPlayers = 0
        self.ageRange = .Pegi3
    }
    
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct GameDTO: Codable {
    var _id: String  // L'ID est généré par la base
    var name: String
    var publisher: String
    var description: String
    var photoURL: String
    var minPlayers: Int
    var maxPlayers: Int
    var ageRange: String
}

struct CreateGameDTO: Codable {
    var name: String
    var publisher: String
    var description: String
    var photoURL: String
    var minPlayers: Int
    var maxPlayers: Int
    var ageRange: String
}
    
