//
//  HomeView.swift
//  IWA
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    @StateObject var transactionListViewModel : TransactionListViewModel = TransactionListViewModel()
    @StateObject var depositListViewModel: DepositListViewModel = DepositListViewModel()
    @EnvironmentObject var sellerListViewModel: SellerListViewModel
    @EnvironmentObject var clientListViewModel: ClientListViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    func action() -> Void {
        print("caca")
    }
    var body: some View {
        VStack {
            Text("Page principale")
                .font(.custom("Poppins-Black", size: 16))
                .padding()
            Button("Print Caca") {
                action()
            }
            NavigationLink(destination: TransactionListView(transactionListViewModel: transactionListViewModel)
                .environmentObject(clientListViewModel)
                .environmentObject(sessionViewModel)
                .environmentObject(sellerListViewModel)) {
                Text("Ventes")
            }
            NavigationLink(destination: DepositListView(depositListViewModel: depositListViewModel)
                .environmentObject(sessionViewModel)) {
                Text("Dépôts")
            }
            //AddButton()
        }
        .onAppear {
            Task {
                try await transactionListViewModel.loadTransactions(sessionId: sessionViewModel.id)
                try await transactionListViewModel.loadTransactionInfos(sessionId: sessionViewModel.id)
            }
            Task {
                try await depositListViewModel.loadDeposits(sessionId: sessionViewModel.id)
            }
        }
        
    }
}
