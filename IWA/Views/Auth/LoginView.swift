import SwiftUI

struct LoginView: View {
    @State private var isPasswordVisible = false
    @State private var errorMessage: String = ""
    @State private var email: String = "admin@example.com"
    @State private var password: String = "SecurePassword123"
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("SE CONNECTER")
                .font(.headline)
                .padding(.top, 20)

            // Champ Email
            TextField("Email", text: $email)
                .textFieldStyle(GenericTextFieldStyle())
                .keyboardType(.emailAddress)

            // Champ Mot de passe avec option d'affichage
            HStack {
                if isPasswordVisible {
                    TextField("Mot de passe", text: $password)
                } else {
                    SecureField("Mot de passe", text: $password)
                }
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .focused($isFocused)
            .background(RoundedRectangle(cornerRadius: 8).stroke(isFocused ? Color.CPLilas : Color.black, lineWidth: isFocused ? 3 : 1))
            .padding(.horizontal, 20)
            

            // Message d'erreur
            if errorMessage != "" {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.poppins(fontStyle: .caption, fontWeight: .light, isItalic: false))
            }

            // Lien "Mot de passe oublié"
            Text("Mot de passe oublié ?")
                .foregroundColor(.black)
                .font(.footnote)
                .underline()

            // Bouton de connexion
            Button() {
                Task {
                    do {
                        errorMessage = ""
                        try await LoginService.login(email: email, password: password)
                    } catch let loginError as LoginError {
                        // Afficher le message d'erreur personnalisé
                        print(loginError.message)
                        errorMessage = loginError.message
                    } catch {
                        // Gérer d'autres erreurs
                        errorMessage = "Une erreur s'est produite."
                    }
                }
            } label: {
                Text("Se connecter")
            }
            .buttonStyle(GenericButtonStyle())
            .disabled(email.isEmpty || password.isEmpty)
        }
    }
}
