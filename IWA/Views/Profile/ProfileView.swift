import SwiftUI

struct ProfileView: View {
    @ObservedObject var managerViewModel: ManagerViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    WhiteCard {
                        VStack(alignment: .center) {
                            
                            // Vendeur
                            Text("Nom : \(managerViewModel.lastName)")

                            Text("Prénom : \(managerViewModel.firstName)")

                            Text("Email : \(managerViewModel.email)")

                            Text("Téléphone : \(managerViewModel.phone)")

                            Text("Adresse : \(managerViewModel.address)")
                            
                        }
                        .padding()
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                }
            }
            
            // ne pas toucher
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    UpdateButton(destination: UpdateProfileView(managerViewModel: self.managerViewModel))
                }
                .padding()
            }
        }
        .withNavigationBar()
        .padding(.vertical, 8)
    }
}
