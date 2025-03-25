//
//  StatBlock.swift
//  IWA
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct StatBlock: View {
    let title: String
    let value: Int
    
    var body: some View {
        VStack(spacing: 6) {
            Text("\(value)")
                .font(.title)
                .bold()
            Text(title)
                .font(.caption)
                .opacity(0.9)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color("CPSecondary").opacity(0.1))
        .cornerRadius(10)
    }
}

struct StatBlock_Previews: PreviewProvider {
    static var previews: some View {
        StatBlock(title: "caca", value: 5)
    }
}
