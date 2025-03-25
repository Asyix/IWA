import SwiftUI

struct SellerSoldGamesView: View {
    @StateObject var sellerViewModel: SellerViewModel

    
    var body: some View {
        if sellerViewModel.sellerTransactions.isEmpty {
            Text("Aucun achat")
        }
        else {
            VStack(spacing: 12) {
                ForEach(sellerViewModel.sellerTransactions, id: \.id) { transaction in
                    HStack(alignment: .top, spacing: 16) {
                        // IMAGE DU JEU
                        AsyncImage(url: transaction.game.photoURL) { phase in
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
                                Text(transaction.game.name)
                                    .font(.headline)
                            }

                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(.blue)
                                Text(String(format: "%.2f €", transaction.depositedGame.salePrice))
                                    .font(.subheadline)
                            }

                            HStack {
                                Image(systemName: "person.2")
                                    .foregroundColor(.green)
                                Text(transaction.client.name)
                                    .font(.footnote)
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


