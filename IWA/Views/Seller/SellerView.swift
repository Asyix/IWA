//
//  SellerView.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

enum SellerTab: String, CaseIterable {
    case bilan = "Bilan"
    case deposited = "Jeux Déposés"
    case sold = "Jeux Vendus"
    case info = "Informations"
}

struct SellerView: View {
    @ObservedObject var sellerViewModel: SellerViewModel
    @State private var selectedTab: SellerTab = .bilan
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Picker("Onglet", selection: $selectedTab) {
                        ForEach(SellerTab.allCases, id: \.self) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Divider()
                    
                    // Affichage conditionnel des vues
                    switch selectedTab {
                    case .info:
                        SellerDetailView()
                    case .bilan:
                        SellerBilanView()
                    case .deposited:
                        SellerDepositedGamesView()
                    case .sold:
                        SellerSoldGamesView()
                    }
                }
            }
            
            // ne pas toucher
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    UpdateButton(destination: UpdateSellerView(sellerViewModel: sellerViewModel))
                }
                .padding()
            }
        }
    }
}

