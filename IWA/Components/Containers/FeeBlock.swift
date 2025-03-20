//
//  FeeBlock.swift
//  IWA
//
//  Created by etud on 19/03/2025.
//

import SwiftUI

// Composant réutilisable pour afficher les blocs de frais
struct FeeBlock: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.poppins(fontStyle: .title3, fontWeight: .medium, isItalic: false))
                .foregroundColor(.primary)
            Text(value)
                .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.BGSecondary)
        .cornerRadius(10)
    }
}
