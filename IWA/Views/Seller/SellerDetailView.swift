import SwiftUI

struct SellerDetailView: View {
    // Données de test
    let fullName = "Jean Pascal"
    let email = "jean@pascal.fr"
    let phone = "0707070707"
    let address = "14 rue Pascal"
    
    let gamesSold = 15
    let gamesForSale = 6
    let gamesRecovered = 3
    
    var body: some View {
        ScrollView {
            BluePurpleCard {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Nom
                    HStack {
                        Image(systemName: "person.fill")
                        Text(fullName)
                            .font(.title2)
                            .bold()
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                    
                    // Coordonnées
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text(email)
                        }
                        HStack {
                            Image(systemName: "phone.fill")
                            Text(phone)
                        }
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Text(address)
                        }
                    }
                    .font(.body)
                    
                    Divider().background(Color.white.opacity(0.5))
                    
                    // Stats de jeux
                    HStack(spacing: 16) {
                        StatBlock(title: "Vendus", value: gamesSold)
                        StatBlock(title: "En vente", value: gamesForSale)
                        StatBlock(title: "Récupérés", value: gamesRecovered)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}


struct SellerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SellerDetailView()
            .preferredColorScheme(.dark)
    }
}

