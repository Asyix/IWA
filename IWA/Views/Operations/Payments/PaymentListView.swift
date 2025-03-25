//
//  PaymentListView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct PaymentListView: View {
    @StateObject private var paymentListViewModel : PaymentListViewModel
    @EnvironmentObject private var sessionViewModel: SessionViewModel

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(paymentListViewModel.paymentList) { payment in
                        //NavigationLink(destination: PaymentView(paymentViewModel: payment)) {
                            //payment row view
                        //}
                    }
                }
                .padding(.top)
            }

            
            
            //ne pas toucher
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton(destination: CreatePaymentView(paymentListViewModel: paymentListViewModel).environmentObject(sessionViewModel))
                }
                .padding()
            }
        }
        .navigationTitle("Paiments")
        .onAppear {
            Task {
                try await paymentListViewModel.loadPayments(sessionId: sessionViewModel.id)
                try await paymentListViewModel.loadPaymentInfos(sessionId: sessionViewModel.id)
            }
        }
        .onChange(of: sessionViewModel.id) { newId in
            Task {
                try await paymentListViewModel.loadPayments(sessionId: sessionViewModel.id)
                try await paymentListViewModel.loadPaymentInfos(sessionId: sessionViewModel.id)
            }
        }
    }
    
}

