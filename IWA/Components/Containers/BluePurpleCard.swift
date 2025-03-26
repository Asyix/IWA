
//  WhiteCard.swift
//  IWA
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct BluePurpleCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#4DA0FF"), Color(hex: "#BC84ED")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .cornerRadius(12) // <-- appliquer ici !
            )
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // ignore the #
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}


