//
//  TabItem.swift
//  IWA
//
//  Created by etud on 12/03/2025.
//

import Foundation
import SwiftUI

enum TabItem: String, CaseIterable, Identifiable {
    case games = "Jeux"
    case clients = "Clients"
    case home = "Home"
    case sellers = "Vendeurs"
    case bilan = "Bilan"
    
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .games: return "gamecontroller.fill"
        case .clients: return "person.2.fill"
        case .home: return "house.fill"
        case .sellers: return "person.crop.rectangle"
        case .bilan: return "chart.bar.fill"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .games: GamesView()
        case .clients: ClientsView()
        case .home: HomeView()
        case .sellers: SellersView()
        case .bilan: BilanView()
        }
    }
 
    var value: Int {
        switch self {
        case .games: return 0
        case .clients: return 1
        case .home: return 2
        case .sellers: return 3
        case .bilan: return 4
        }
    }
}
