// PersonRowView.swift
// IWA

import SwiftUI

struct SellerRowView: View {
    @ObservedObject var sellerViewModel: SellerViewModel

    var body: some View {
        BluePurpleCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "person")
                    Text(sellerViewModel.name)
                        .font(.title2)
                        .bold()
                }

                Divider().overlay(Color.white)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "envelope")
                        Text(sellerViewModel.email)
                    }
                    HStack {
                        Image(systemName: "phone")
                        Text(sellerViewModel.phone)
                    }
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Adresse inconnue") // à remplacer si tu ajoutes un champ `address`
                    }
                }
                .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(4)
    }
}


