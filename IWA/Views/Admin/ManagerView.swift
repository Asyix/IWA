//
//  ManagerView.swift
//  IWA
//
//  Created by etud on 25/03/2025.
//
import SwiftUI


struct ManagerView: View {
    @StateObject var managerViewModel: ManagerViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    BluePurpleCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.blue)
                                Text("\(managerViewModel.firstName) \(managerViewModel.lastName)")
                                    .font(.title2)
                                    .bold()
                            }

                            Divider().overlay(Color.white)

                            // Email, téléphone, adresse
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "envelope")
                                        .foregroundColor(.blue)
                                    Text(managerViewModel.email)
                                        .font(.body)
                                }
                                HStack {
                                    Image(systemName: "phone")
                                        .foregroundColor(.blue)
                                    Text(managerViewModel.phone)
                                        .font(.body)
                                }
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(.blue)
                                    Text(managerViewModel.address)
                                        .font(.body)
                                }
                            }
                            .font(.body)
                            
                            // Admin status
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(managerViewModel.admin ? .green : .red)
                                Text(managerViewModel.admin ? "Admin" : "Non Admin")
                                    .font(.body)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                }
                
                // Additional Information (Transactions, etc.) if needed
                VStack(spacing: 12) {
                    // Display other details such as manager transactions or any other related info
                }
                .padding(.bottom, 50)
            }
            
            // Button to modify manager details
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: UpdateManagerView(managerViewModel: managerViewModel)
                                    .environmentObject(sessionViewModel)) {
                        Text("Modifier")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Détail Manager")
        .withNavigationBar()
    }
}

