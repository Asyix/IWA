//
//  HomeView.swift
//  IWA
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    func action() -> Void {
        print("caca")
    }
    var body: some View {
        VStack {
            Text("Page principale")
                .font(.custom("Poppins-Black", size: 16))
                .padding()
            Button("Print Caca") {
                action()
            }
            //AddButton()
        }
    }
}
