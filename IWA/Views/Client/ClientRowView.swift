// PersonRowView.swift
// IWA

import SwiftUI

struct ClientRowView: View {
    @ObservedObject var clientViewModel: ClientViewModel
    @State var name: String
    @State var email: String
    @State var phone: String
    @State var address: String
    
    init(clientViewModel: ClientViewModel) {
        self.clientViewModel = clientViewModel
        self._email = State(initialValue: clientViewModel.email)
        self._name = State(initialValue: clientViewModel.name)
        self._phone = State(initialValue: clientViewModel.phone)
        self._address = State(initialValue: clientViewModel.address)
    }

    var body: some View {
        BluePurpleCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "person")
                    Text(name)
                        .font(.title2)
                        .bold()
                }

                Divider().overlay(Color.white)

                // Email, téléphone, adresse
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "envelope")
                        Text(email)
                    }
                    HStack {
                        Image(systemName: "phone")
                        Text(phone)
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
        .onChange(of: clientViewModel.name) { newName in
            self.name = newName
        }
        .onChange(of: clientViewModel.email) { newEmail in
            self.email = newEmail
        }
        .onChange(of: clientViewModel.phone) { newPhone in
            self.phone = newPhone
        }
        .onChange(of: clientViewModel.address) { newAddress in
            self.address = newAddress
        }
        .padding(4)
    }
}


