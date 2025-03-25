import SwiftUI

struct SellerBilanView: View {
    let gamesSold = 15
    let gamesForSale = 6
    let gamesRecovered = 3
    
    var body: some View {
        ScrollView{
            VStack(spacing: 16) {
                // Stats de jeux
                HStack(spacing: 16) {
                    StatBlock(title: "Vendus", value: gamesSold)
                    StatBlock(title: "En vente", value: gamesForSale)
                    StatBlock(title: "Récupérés", value: gamesRecovered)
                }
                StatBlock(title: "Montant du pour la session ", value : 60)
                StatBlock(title: "Total des ventes pour la session", value : 45)
            }
            .padding()
            
        }
    }
    
    struct SellerStatBlock: View {
        let title: String
        let value: Int
        
        var body: some View {
            VStack(spacing: 6) {
                Text("\(value)")
                    .font(.title)
                    .bold()
                Text(title)
                    .font(.caption)
                    .opacity(0.9)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)
        }
    }
}


struct SellerBilanView_Previews: PreviewProvider {
    static var previews: some View {
        SellerBilanView()
    }
}

