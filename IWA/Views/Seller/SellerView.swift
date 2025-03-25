//
//  SellerView.swift
//  IWA
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

enum SellerTab: String, CaseIterable {
    case deposited = "Jeux Déposés"
    case sold = "Jeux Vendus"
    
}

struct SellerView: View {
    @ObservedObject var sellerViewModel: SellerViewModel
    @State private var selectedTab: SellerTab = .deposited
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    VStack {
                        BluePurpleCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "person")
                                    Text(sellerViewModel.name)
                                        .font(.title2)
                                        .bold()
                                }

                                Divider().overlay(Color.white)

                                // Email, téléphone, adresse
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "envelope")
                                        Text(sellerViewModel.email)
                                    }
                                    HStack {
                                        Image(systemName: "phone")
                                        Text(sellerViewModel.phone) 
                                    }
                                }
                                .font(.body)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                    }
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
                    case .deposited:
                        SellerDepositedGamesView(sellerViewModel : sellerViewModel)
                    case .sold:
                        SellerSoldGamesView(sellerViewModel : sellerViewModel)
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

