//
//  TransactionListView.swift
//  IWA
//
//  Created by etud on 24/03/2025.
//

import Foundation
import SwiftUI

struct RefundListView: View {
    @StateObject var refundListViewModel : RefundListViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(refundListViewModel.refundList) { refund in
                        RefundRowView(refund: refund) // Ajout de TransactionRowView pour chaque transaction
                    }
                }
                .padding(.top)
            }

            
            
            //ne pas toucher
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton(destination: CreateRefundView(refundListViewModel: refundListViewModel)
                        .environmentObject(sessionViewModel))
                }
                .padding()
            }
        }
        .navigationTitle("Ventes")
        .withNavigationBar()
        .withSessionSelector(sessionViewModel: sessionViewModel)
        .onAppear {
            Task {
                try await refundListViewModel.loadRefunds(sessionId: sessionViewModel.id)
                try await refundListViewModel.loadRefundInfos(sessionId: sessionViewModel.id)
            }
        }
    }
    
}

