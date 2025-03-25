import SwiftUI

struct UpdateProfileView: View {
    @ObservedObject var managerViewModel: ManagerViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var email: String
    @State var firstName: String
    @State var lastName: String
    @State var phone: String
    @State var address: String
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    init(managerViewModel: ManagerViewModel) {
        self.managerViewModel = managerViewModel
        self._firstName = State(initialValue: managerViewModel.firstName)
        self._lastName = State(initialValue: managerViewModel.lastName)
        self._phone = State(initialValue: managerViewModel.phone)
        self._address = State(initialValue: managerViewModel.address)
        self._email = State(initialValue: managerViewModel.email)
    }
    
    private func updateManager() async -> Bool {
        if [email, firstName, lastName, phone, address].contains(where: { $0.isEmpty }) {
            errorMessage = "Veuillez remplir tous les champs."
            return false
        }
        if phone.count < 10 {
            errorMessage = "Veuillez rentrer un numéro de téléphone à 10 chiffres."
            return false
        }

        isLoading = true
        errorMessage = nil

        let managerDTO = ManagerDTO(_id: managerViewModel.id, firstName: firstName, lastName: lastName, email: email, phone: phone, address: address, admin: false)
        do {
            try await managerViewModel.updateManager(managerDTO: managerDTO)
            isLoading = false
        }
        catch let managerError as RequestError {
            errorMessage = managerError.message
            isLoading = false
            return false
        }
        catch {
            errorMessage = "Une erreur s'est produite"
            isLoading = false
            return false
        }
        return true
        
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                WhiteCard {
                    Text("Modifier mon profil")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 12) {
                        
                        TextField("Nom", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Prénom", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Adresse Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Numéro de téléphone", text: $phone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        TextField("Adresse Postale", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        
                    }
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.poppins(fontStyle: .caption, fontWeight: .medium, isItalic: false))
                        .padding()
                }
                
                Button(action: {
                    Task {
                        let success = await updateManager()
                        if success { dismiss() }
                    }
                    
                    
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Modifier")
                            .font(.poppins(fontStyle: .title3, fontWeight: .bold, isItalic: false))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(isLoading)
            }
            .padding()
        }
        .withNavigationBar()
    }
}

