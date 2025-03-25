// PersonRowView.swift
// IWA

import SwiftUI

struct ClientRowView: View {
    @ObservedObject var clientViewModel: ClientViewModel

    var body: some View {
        BluePurpleCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "person")
                    Text(clientViewModel.name)
                        .font(.title2)
                        .bold()
                }

                Divider().overlay(Color.white)

                // Email, téléphone, adresse
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "envelope")
                        Text(clientViewModel.email)
                    }
                    HStack {
                        Image(systemName: "phone")
                        Text("N/A") // Remplace si tu as un champ phone plus tard
                    }
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(clientViewModel.address)
                    }
                }
                .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(4)
    }
}


