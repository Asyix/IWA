//
//  AddButton.swift
//  IWA
//
//  Created by etud on 14/03/2025.
//

import SwiftUI

struct AddButton<Destination: View>: View {
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.CPsecondary)
                .padding(10)
        }
        .buttonStyle(ActionButtonStyle())
    }
}
