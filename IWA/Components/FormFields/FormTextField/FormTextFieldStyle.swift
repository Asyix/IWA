//
//  TextFieldStyle.swift
//  IWA
//
//  Created by etud on 14/03/2025.
//

import SwiftUI

struct FormTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .font(.custom("Poppins-Back", size: 16))
    }
}
