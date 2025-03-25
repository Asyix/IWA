import SwiftUI

struct CreateGameView: View {
    @ObservedObject var gameListViewmodel: GameListViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var publisher: String = ""
    @State private var photoURL: String = ""
    @State private var minPlayers: String = ""
    @State private var maxPlayers: String = ""
    @State private var ageRange: AgeRange = .Pegi3
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private func createGame() async -> Bool {
        if [name, description, publisher, photoURL, minPlayers, maxPlayers].contains(where: { $0.isEmpty }) {
            errorMessage = "Veuillez remplir tous les champs."
            return false
        }
        guard let minPlayers = Int(minPlayers),
              let maxPlayers = Int(maxPlayers) else {
            errorMessage = "Veuillez entrer des valeurs numériques valides pour le nombre de joueurs."
            return false
        }

        isLoading = true
        errorMessage = nil
        
        let createGameDTO = CreateGameDTO(
            name: name,
            publisher: publisher,
            description: description,
            photoURL: photoURL,
            minPlayers: minPlayers,
            maxPlayers: maxPlayers,
            ageRange: ageRange.rawValue
        )
        do {
            try await gameListViewmodel.create(createGameDTO: createGameDTO)
            isLoading = false
            return true
        }
        catch let gameError as RequestError {
            errorMessage = gameError.message
            isLoading = false
            return false
        }
        catch {
            errorMessage = "Une erreur s'est produite"
            isLoading = false
            return false
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                WhiteCard {
                    Text("Créer un nouveau jeu")
                        .font(.poppins(fontStyle: .title, fontWeight: .bold, isItalic: false))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 12) {
                        TextField("Nom du jeu", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Editeur", text: $publisher)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Lien de l'image", text: $photoURL)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                WhiteCard {
                    VStack(spacing: 12) {
                        TextField("Nombre de joueurs min", text: $minPlayers)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        TextField("Nombre de joueurs max", text: $maxPlayers)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        Picker("Tranche d'âge", selection: $ageRange) {
                            ForEach(AgeRange.allCases.filter { $0.isPegi }) { range in
                                Text(range.rawValue).tag(range)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                WhiteCard {
                    Text("Description")
                    TextEditor(text: $description)
                            .frame(minHeight: 100)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.poppins(fontStyle: .caption, fontWeight: .medium, isItalic: false))
                        .padding()
                }
                
                Button(action: {
                    Task {
                        let success = await createGame()
                        if success { dismiss() }
                    }
                    
                    
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Créer ce jeu")
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
