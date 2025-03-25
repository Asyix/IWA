//
//  ManagerView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//
import SwiftUI


struct ManagerView: View {
    @StateObject var managerViewModel: ManagerViewModel
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    BluePurpleCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "person")
                                Text("\(managerViewModel.firstName) \(managerViewModel.lastName)")
                                    .font(.title2)
                                    .bold()
                            }

                            Divider().overlay(Color.white)

                            // Email, téléphone, adresse
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "envelope")
                                    //Text(clientViewModel.email)
                                }
                                HStack {
                                    Image(systemName: "phone")
                                    //Text("N/A") // Remplace si tu as un champ phone plus tard
                                }
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                    //Text(clientViewModel.address)
                                }
                            }
                            .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                }
                    VStack(spacing: 12) {
                        
                    }
                    .padding(.bottom, 50)
            }
            
            // ne pas toucher
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    UpdateButton(destination: UpdateManagerView(managerViewModel: managerViewModel))
                }
                .padding()
            }
        }
        .navigationTitle("Détail client")
        .withNavigationBar()
    }
}


