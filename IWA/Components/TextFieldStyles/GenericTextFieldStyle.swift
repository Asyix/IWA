//
//  GenericButtonStyle.swift
//  IWA
//
//  Created by etud on 17/03/2025.
//

import SwiftUI

struct GenericTextFieldStyle : TextFieldStyle {
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.poppins(fontStyle: .body, fontWeight: .regular, isItalic: false))
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).stroke(isFocused ? Color.CPLilas : Color.black, lineWidth: isFocused ? 3 : 1))
            .autocapitalization(.none)
            .padding(.horizontal, 20)
            .focused($isFocused)
            
    }
}

struct textFieldPreview : PreviewProvider {
    @State private var email = ""
    static var previews: some View {
        VStack {
        }
    }
}
