import SwiftUI

struct SellerDepositedGamesView: View {
    @StateObject var sellerViewModel: SellerViewModel
    
    var body: some View {
        if sellerViewModel.depositedGames.isEmpty {
            Text("Aucun achat")
        }
        else {
            VStack(spacing: 12) {
                ForEach(sellerViewModel.depositedGames, id: \.id) { depositedGame in
                    HStack(alignment: .top, spacing: 16) {
                        // IMAGE DU JEU
                        AsyncImage(url: depositedGame.game.photoURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(10)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        // INFOS TRANSACTION
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "gamecontroller.fill")
                                    .foregroundColor(.purple)
                                Text(depositedGame.game.name)
                                    .font(.headline)
                            }
                            
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(.blue)
                                Text(String(format: "%.2f €", depositedGame.depositedGame.salePrice))
                                    .font(.subheadline)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 50)
        }
    }
    
}
