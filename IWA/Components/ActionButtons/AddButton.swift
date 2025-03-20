//
//  AddButton.swift
//  IWA
//
//  Created by etud on 14/03/2025.
//

import SwiftUI

struct AddButton: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: self.action, label: {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.CPsecondary)
                .padding(20)
            
        })
        .buttonStyle(AddButtonStyle())
    }
}
