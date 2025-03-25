import SwiftUI

struct PaymentRowView: View {
    @ObservedObject var payment: PaymentViewModel
    
    var body: some View {
        WhiteCard {
            HStack {
                VStack(alignment: .center) {
                    
                    // Vendeur
                    Text("Vendeur : \(payment.sellerId)")

                    Text("Montant : €\(refund.depositFeePayed, specifier: "%.2f")")

                    Text("Date : \(refund.depositDate)")
                }
            }
            .padding()
        }
        .withNavigationBar()
        .padding(.vertical, 8)
    }
}

