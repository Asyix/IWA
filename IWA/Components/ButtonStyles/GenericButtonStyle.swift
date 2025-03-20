//
//  GenericButtonStyle.swift
//  IWA
//
//  Created by etud on 17/03/2025.
//

import SwiftUI

struct GenericButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.poppins(fontStyle: .title3, fontWeight: .semibold, isItalic: false))
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(.white)
            .background(Color.CPLilas)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            //.opacity(configuration.isPressed ? 0.8 : 1.0)
            
    }
}

struct Preview : PreviewProvider {
    static var previews: some View {
        VStack {
            Button() {
                
            } label: {
                Text("Se connecter")
                    
            }.buttonStyle(GenericButtonStyle())
        }
    }
}
