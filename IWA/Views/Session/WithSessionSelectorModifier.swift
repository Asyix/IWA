//
//  WithSessionSelectorModifier.swift
//  IWA
//
//  Created by etud on 17/03/2025.
//

import Foundation

import SwiftUI

struct WithSessionSelectorModifier: ViewModifier {
    @StateObject var sessionViewModel : SessionViewModel
    @State var isOnSessionView : Bool = false
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            SessionSelectorView(sessionViewModel: sessionViewModel, isOnSessionView: isOnSessionView)
                .frame(maxWidth: .infinity)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

extension View {
    func withSessionSelector(sessionViewModel : SessionViewModel, isOnSessionView : Bool = false) -> some View {
        self.modifier(WithSessionSelectorModifier(sessionViewModel: sessionViewModel, isOnSessionView: isOnSessionView))
    }
}
