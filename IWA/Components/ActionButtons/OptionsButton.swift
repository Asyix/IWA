//
//  OptionsButton.swift
//  IWA
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct OptionsButton: View {
    var action: () -> Void = {}
    var body: some View {
        Button(action: self.action, label: {
            Image(systemName: "ellipsis")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.CPsecondary)
                .padding(20)
            
        })
        .buttonStyle(OptionsButtonStyle())
    }
}

struct OptionsButton_Previews: PreviewProvider {
    static var previews: some View {
        OptionsButton()
    }
}
