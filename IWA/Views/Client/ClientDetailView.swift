import SwiftUI

struct ClientDetailView: View {
    @ObservedObject var clientViewModel: ClientViewModel

    var body: some View {
        ScrollView {
            BluePurpleCard {
                VStack(alignment: .leading, spacing: 20) {
                    // Nom
                    HStack {
                        Image(systemName: "person.fill")
                        Text(clientViewModel.name)
                            .font(.title2)
                            .bold()
                    }

                    Divider().background(Color.white.opacity(0.5))

                    // Coordonnées
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text(clientViewModel.email)
                        }
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("N/A") // Si tu veux gérer le champ phone plus tard
                        }
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Text(clientViewModel.address)
                        }
                    }
                    .font(.body)

                    Divider().background(Color.white.opacity(0.5))

                    // Stats de jeux
                    HStack(spacing: 16) {
                        StatBlock(title: "Nombre de jeux achetés", value: clientViewModel.nbBought)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}


