//
//  RefundListView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct RefundListView: View {
    @StateObject private var refundListViewModel : RefundListViewModel
    @EnvironmentObject private var sessionViewModel: SessionViewModel

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(refundListViewModel.refundList) { refund in
                        RefundRowView(refundViewModel: refund) {

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
                    AddButton(destination: CreateRefundView(refundListViewModel: refundListViewModel).environmentObject(sessionViewModel))
                }
                .padding()
            }
        }
        .withNavigationBar()
        .navigationTitle("Remboursements")
        .onAppear {
            Task {
                try await refundListViewModel.loadRefunds(sessionId: sessionViewModel.id)
                try await refundListViewModel.loadRefundInfos(sessionId: sessionViewModel.id)
            }
        }
        .onChange(of: sessionViewModel.id) { newId in
            Task {
                try await refundListViewModel.loadRefunds(sessionId: sessionViewModel.id)
                try await refundListViewModel.loadRefundInfos(sessionId: sessionViewModel.id)
            }
        }
    }
    
}

