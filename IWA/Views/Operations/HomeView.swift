//
//  HomeView.swift
//  IWA
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var transactionListViewModel : TransactionListViewModel = TransactionListViewModel()
    @StateObject var depositListViewModel: DepositListViewModel = DepositListViewModel()
    @StateObject var refundListViewModel : RefundListViewModel = RefundListViewModel()
    @StateObject var paymentListViewModel : PaymentListViewModel = PaymentListViewModel()
    @EnvironmentObject var sellerListViewModel: SellerListViewModel
    @EnvironmentObject var clientListViewModel: ClientListViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel

    var body: some View {
        VStack {
            // Logo avec bords arrondis
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 150)
            
            Spacer()
            Text("DÉPOSER UN JEU")
                .font(.poppins(fontStyle: .title2, fontWeight: .bold, isItalic: false))
                .foregroundColor(Color(hex: "#00e0b3"))
                .padding(6)
            NavigationLink(destination: DepositListView(depositListViewModel: depositListViewModel)
                .environmentObject(sessionViewModel)) {
                    Image("depot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 20))  // Ajoute des bords arrondis
            }
        
            Text("VENDRE UN JEU")
                .font(.poppins(fontStyle: .title2, fontWeight: .bold, isItalic: false))
                .foregroundColor(Color(hex: "#1da2ff"))
                .padding(6)

            NavigationLink(destination: TransactionListView(transactionListViewModel: transactionListViewModel)
                .environmentObject(clientListViewModel)
                .environmentObject(sessionViewModel)
                .environmentObject(sellerListViewModel)) {
                Image("vente")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20))  // Ajoute des bords arrondis
            }
            Spacer()
        }
        .onAppear {
            Task {
                try await transactionListViewModel.loadTransactions(sessionId: sessionViewModel.id)
                try await transactionListViewModel.loadTransactionInfos(sessionId: sessionViewModel.id)
            }
            Task {
                try await depositListViewModel.loadDeposits(sessionId: sessionViewModel.id)
            }
            Task {
                try await refundListViewModel.loadRefundInfos(sessionId: sessionViewModel.id)
                try await refundListViewModel.loadRefunds(sessionId: sessionViewModel.id)
            }
        }
    }
}


