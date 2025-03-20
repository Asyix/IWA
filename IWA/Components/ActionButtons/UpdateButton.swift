//
//  UpdateButton.swift
//  IWA
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct UpdateButton<Destination: View>: View {
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            Image(systemName: "pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.CPsecondary)
                .padding(10)
        }
        .buttonStyle(ActionButtonStyle())
    }
}

/*
struct UpdateButton_Previews: PreviewProvider {
    @State var path: NavigationPath = NavigationPath()
    static var previews: some View {
        NavigationStack {
            UpdateButton(destination: {
                GamesView(path: $path)
            }, path: $path)
        }
    }
}*/
