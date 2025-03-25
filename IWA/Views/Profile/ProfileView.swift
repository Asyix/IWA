import SwiftUI

struct ProfileView: View {
    @StateObject var managerViewModel: ManagerViewModel

    init() {
        _managerViewModel = StateObject(wrappedValue: ManagerViewModel(manager: managerService.getProfile()))
    }
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    WhiteCard {
                        VStack(alignment: .center) {
                            
                            // Vendeur
                            Text("Nom : \(manager.lastName)")

                            Text("Prénom : \(manager.firstName)")

                            Text("Email : \(manager.email)")

                            Text("Téléphone : \(manager.phone)")

                            Text("Adresse : \(manager.address)")
                            
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
