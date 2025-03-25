//
//  SessionSelectorView.swift
//  IWA
//
//  Created by etud on 17/03/2025.
//

import SwiftUI

struct SessionSelectorView: View {
    @StateObject var sessionViewModel: SessionViewModel
    @State var isOnSessionView : Bool = false

    var body: some View {
        HStack {
            SelectorView(
                items: sessionViewModel.sessions,
                selectedItem: $sessionViewModel.selectedSession,
                displayTransform: { session in
                        session == sessionViewModel.currentSession ? session.name + " - Active" : session.name
                }
            )
            // Info button
            NavigationLink(destination: SessionView(sessionViewModel: sessionViewModel)) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
            .disabled(isOnSessionView)
        }
        .padding(.horizontal)
        .background(
        )
    }

        /// Detect if the current view is already the session page
        private func isOnSessionPage() -> Bool {
            return false
        }
}

