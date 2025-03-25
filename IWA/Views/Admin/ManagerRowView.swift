//
//  ManagerRowView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//

import SwiftUI

struct ManagerRowView: View {
    var manager: ManagerViewModel
    @State var firstName: String
    @State var lastName:String
    @State var email: String
    
    init(manager: ManagerViewModel) {
        self.manager = manager
        self._firstName = State(initialValue: manager.firstName)
        self._lastName = State(initialValue: manager.lastName)
        self._email = State(initialValue: manager.email)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(firstName) \(lastName)")
                    .font(.headline)
                Text(manager.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(manager.admin ? "Admin" : "Non Admin")
                    .font(.caption)
                    .foregroundColor(manager.admin ? .green : .red)
            }
            
            Spacer()
        }
        .onChange(of: manager.firstName) { newName in
            self.firstName = newName
        }
        .onChange(of: manager.lastName) { newName in
            self.lastName = newName
        }
        .onChange(of: manager.email) { newEmail in
            self.email = newEmail
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
