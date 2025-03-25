//
//  TransactionListView.swift
//  IWA
//
//  Created by etud on 24/03/2025.
//

import Foundation
import SwiftUI

struct TransactionListView: View {
    @StateObject var transactionListViewModel : TransactionListViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var sellerListViewModel: SellerListViewModel
    @EnvironmentObject var clientListViewModel: ClientListViewModel

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(transactionListViewModel.transactionList) { transaction in
                        TransactionRowView(transaction: transaction) // Ajout de TransactionRowView pour chaque transaction
 
                    }
                }
                .padding(.top)
            }

            
            
            //ne pas toucher
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton(destination: CreateTransactionView(transactionListViewModel: transactionListViewModel)
                        .environmentObject(clientListViewModel)
                        .environmentObject(sessionViewModel)
                        .environmentObject(sellerListViewModel))
                }
                .padding()
            }
        }
        .navigationTitle("Ventes")
        .withNavigationBar()
        .withSessionSelector(sessionViewModel: sessionViewModel)
        .onAppear {
            Task {
                try await transactionListViewModel.loadAll(sessionId: sessionViewModel.id)
            }
        }
        .onChange(of: sessionViewModel.id) { newId in
            Task {
                try await transactionListViewModel.loadAll(sessionId: sessionViewModel.id)
            }
        }
    }
    
}

