//
//  ContentView.swift
//  IWA
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if authManager.isAuthenticated {
                    TabBar()
                        .transition(.opacity)
                        .environmentObject(sessionViewModel)
                } else {
                    LoginView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: authManager.isAuthenticated)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
