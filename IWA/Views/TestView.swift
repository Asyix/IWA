//
//  TestView.swift
//  IWA
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct TestView: View {
    @Environment(\.dismiss) var dismiss
    
    func printpath() {
        print("path")
    }
    var body: some View {
            Button() {
                dismiss()
            } label: {
                Text("x")
            }.onAppear(perform: printpath)
    }
}
