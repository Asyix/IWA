//
//  WhiteCard.swift
//  IWA
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct WhiteCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .padding(10)
        .background(Color("BGSecondary"))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
    }
}
