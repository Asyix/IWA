import SwiftUI

struct InfoTag: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.footnote)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .background(Color("BGTertiary"))
            .cornerRadius(8)
    }
}

struct GameView: View {
    @StateObject var gameViewModel: GameViewModel
    
    @State var selectedSaleOption: Int = 0

    var body: some View {
        ZStack {
            ScrollView {
                WhiteCard {
                    VStack(spacing: 16) {
                        // Titre
                        Text(gameViewModel.name)
                            .font(.poppins(fontStyle: .title, fontWeight: .semibold, isItalic: false))
                    
                        // Image du jeu
                        AsyncImage(url: gameViewModel.photoURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .frame(width: 180, height: 180)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width:180, height: 180)
                                .overlay(Text("Chargement de l'image...")
                                    .font(.poppins(fontStyle: .caption, fontWeight: .light, isItalic: false)))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                if !gameViewModel.saleOptions.isEmpty {
                    WhiteCard {
                        // Menu déroulant
                        Picker("Options", selection: $selectedSaleOption) {
                            ForEach(0..<gameViewModel.saleOptions.count, id: \.self) { i in
                                let option = gameViewModel.saleOptions[i]
                                Text("\(String(format: "%.2f", option.price)) € • \(option.seller.name) • \(option.quantity) en stock")
                                    .tag(i)
                                    .foregroundColor(Color("CPSecondary"))
                                    .font(.poppins(fontStyle: .caption2, fontWeight: .light, isItalic: false))
                            }
                        }
                        .pickerStyle(.menu)
                        .background(Color("BGTertiary"))
                        .cornerRadius(8)
                        
                        // Nombre d’options
                        Text("\(gameViewModel.saleOptions.count - 1) autres options disponibles")
                            .font(.footnote)
                            .foregroundColor(Color("CPSecondary"))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                WhiteCard {
                    // Infos générales du jeu
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        InfoTag(title: gameViewModel.publisher)
                        InfoTag(title: "\(gameViewModel.minPlayers)-\(gameViewModel.maxPlayers) joueurs")
                        InfoTag(title: gameViewModel.ageRange.rawValue)
                    }
                }
                
                WhiteCard {
                    
                    // Infos sur l’option sélectionnée
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        InfoTag(title: "Vendus : \(gameViewModel.sold)")
                        InfoTag(title: "En vente : \(gameViewModel.nbForSale)")
                        InfoTag(title: "Récupérés : \(gameViewModel.pickedUp)")
                    }
                }
                
                WhiteCard {
                    // Description
                    VStack(alignment: .center, spacing: 8) {
                        Text("Description")
                            .font(.poppins(fontStyle: .headline, fontWeight: .semibold, isItalic: false))
                            .foregroundColor(Color("CPSecondary"))
                        Text(gameViewModel.description)
                            .font(.poppins(fontStyle: .body, fontWeight: .light, isItalic: false))
                            .foregroundColor(Color("CPSecondary"))
                    }
                    .padding()
                    .background(.white.opacity(0.1))
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                    
            }

            // Bouton superposé (Z index : 1)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    UpdateButton(destination: UpdateGameView(gameViewModel: gameViewModel))
                }
                .padding()
            }
        }
        .padding(.top, 5)
        .navigationTitle("Détail du jeu")
        //.withSessionSelector()
        .withNavigationBar()
    }
}

