import SwiftUI

struct PaymentRowView: View {
    @ObservedObject var payment: PaymentViewModel
    
    var body: some View {
        WhiteCard {
            HStack {
                VStack(alignment: .center) {
                    
                    // Vendeur
                    Text("Vendeur : \(payment.seller.name)")

                    Text("Montant : €\(payment.depositFeePayed, specifier: "%.2f")")

                    Text("Date : \(payment.depositDate)")
                }
            }
            .padding()
        }
        .withNavigationBar()
        .padding(.vertical, 8)
    }
}

