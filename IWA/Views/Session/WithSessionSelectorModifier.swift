//
//  WithSessionSelectorModifier.swift
//  IWA
//
//  Created by etud on 17/03/2025.
//

import Foundation

import SwiftUI

struct WithSessionSelectorModifier: ViewModifier {
    @State var isOnSessionView : Bool = false

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            SessionSelectorView(isOnSessionView: isOnSessionView)
                .frame(maxWidth: .infinity)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

extension View {
    func withSessionSelector(isOnSessionView : Bool = false) -> some View {
        self.modifier(WithSessionSelectorModifier(isOnSessionView: isOnSessionView))
    }
}
