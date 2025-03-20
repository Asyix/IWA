//
//  AddButtonStyle.swift
//  IWA
//
//  Created by etud on 14/03/2025.
//

import SwiftUI

struct OptionsButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.CPsecondary) // Icon color adapts
            .background(Color.CPprimary.opacity(0.4)) // Background adapts
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.CPsecondary, lineWidth: 2) // Border adapts
            )
            .shadow(color: Color.CPsecondary.opacity(0.3), radius: 4, x: 2, y: 2) // Shadow adapts
    }
}
