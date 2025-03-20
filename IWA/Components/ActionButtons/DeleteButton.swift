//
//  DeleteButton.swift
//  IWA
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct DeleteButton: View {
    @State var isShowingDialog : Bool = false
    var title: String
    var action: () -> Void = {}
    
    var body: some View {
        Button() {
            isShowingDialog = true
        } label: {
            Image(systemName: "trash")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.CPsecondary)
                .padding(10)
            
        }
        .buttonStyle(ActionButtonStyle())
        .confirmationDialog(title, isPresented: $isShowingDialog, titleVisibility: .visible) {
            Button("Confirmer", role: .destructive, action: action)
            Button("Annuler", role: .cancel) {
                isShowingDialog = false
            }
        }
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton(title: "Etes vous sur de vouloir supprimer cette session ?")
    }
}
