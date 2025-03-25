//
//  WhiteCardSecondary.swift
//  IWA
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct WhiteCardSecondary<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .padding()
        .background(Color("BGTertiary"))
        .cornerRadius(12)
        .shadow(color: .BGSecondary.opacity(0.2), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}

struct WhiteCardSecondary_Previews: PreviewProvider {
    static var previews: some View {
        WhiteCardSecondary {
            FeeBlock(title: "caca", value: "caca")
        }
    }
}
