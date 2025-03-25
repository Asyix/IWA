//
//  SellersView.swift
//  IWA
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct SellerListView: View {
    @EnvironmentObject private var sessionViewModel : SessionViewModel
    @ObservedObject var sellerListViewModel: SellerListViewModel
    @State var lastSessionId : String = "x"

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(sellerListViewModel.sellerList) { seller in
                        NavigationLink(destination: SellerView(sellerViewModel: seller)) {
                            SellerRowView(sellerViewModel: seller)
                                .frame(maxWidth: .infinity)
                                .environmentObject(sessionViewModel)
                        }
                    }
                }
                .padding(.top)
            }

            
            
            //ne pas toucher
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton(destination: CreateSellerView(sellerListViewModel: sellerListViewModel))
                }
                .padding()
            }
        }
        .navigationTitle("Vendeurs")
        .onAppear {
            lastSessionId = sessionViewModel.id
            Task {
                try await sellerListViewModel.loadSellers()
                try await sellerListViewModel.loadSellerInfos(sessionId: sessionViewModel.id)
            }
        }
        .onChange(of: sessionViewModel.id) { newId in
            Task {
                try await sellerListViewModel.loadSellerInfos(sessionId: newId)
            }
        }
    }
    
}
