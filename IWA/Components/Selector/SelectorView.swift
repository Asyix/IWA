//
//  SelectorView.swift
//  IWA
//
//  Created by etud on 17/03/2025.
//

import SwiftUI

struct SelectorView<T: Hashable>: View {
    let items: [T]
    @Binding var selectedItem: T
    let displayTransform: (T) -> String // Permet de customiser l'affichage des éléments

    var body: some View {
        Menu {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    selectedItem = item
                }) {
                    Text(displayTransform(item))
                }
            }
        } label: {
            HStack {
                Text(displayTransform(selectedItem))
                    .foregroundColor(.blue)
                Image(systemName: "chevron.down")
                    .foregroundColor(.blue)
            }
            .padding()
            .frame(maxWidth: .infinity) 
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

