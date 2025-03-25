//
//  DepositRowView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct RefundRowView: View {
    @ObservedObject var refund: RefundViewModel
    
    var body: some View {
        WhiteCard {
            HStack {
                VStack(alignment: .center) {
                    
                    // Vendeur
                    Text("Vendeur : \(refund.sellerId)")

                    Text("Montant : €\(refund.refundAmount, specifier: "%.2f")")

                    Text("Date : \(refund.refundDate)")
                }
            }
            .padding()
        }
        .withNavigationBar()
        .padding(.vertical, 8)
    }
}

