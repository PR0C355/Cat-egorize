import SwiftUI
import SwiftData
import Supabase

struct ContentView: View {
    let client = SupabaseClient(supabaseURL: URL(string: "https://cat-egorize.sanguinare.dev")!, supabaseKey: "")
    
    @State private var tabState = ""
    @State private var user: User?
    @State private var isAuthenticated = false
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    
    var body: some View {
        Group {
            if isAuthenticated {
                authenticatedView
            } else {
                loginView
            }
        }
        .onAppear {
            checkAuthStatus()
        }
    }
    
    var authenticatedView: some View {
        TabView(selection: $tabState) {
            UserProfileView(user: user!)
                .tabItem {
                    Label("Home", systemImage: "person.circle")
                }
                .tag("home")
            
            AddSightingView(tabState: $tabState)
                .tabItem {
                    Label("Add Sighting", systemImage: "plus.circle")
                }
                .tag("add")
                .toolbar(.hidden, for: .tabBar)
            
            LocalFeedView(sightings: sampleSightings)
                .tabItem {
                    Label("Local", systemImage: "map")
                }
                .tag("local")
        }
    }
    
    var loginView: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Login") {
                login()
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    func checkAuthStatus() {
        print("Checking Authentication Status")
        Task {
            do {
                let session = try await client.auth.session
                
                let sessionUser = session.user
//                let userID = session.user.id
                let userEmail = session.user.email
//                let userName = session.user.userMetadata.first(where: { $0.key == "name" })?.value
//                let userAvatarURL = session.user.userMetadata.first(where: { $0.key == "avatar_url" })?.value
                
                

//                user = User(
//                    id: userID,
//                    username: userEmail!,
//                    profilePicture: userEmail!,
//                    userLocation: "Chapel Hill, NC",
//                    cats: []
//                    sightings: []
//                )
                
                user = genData(email: userEmail!)
                
                isAuthenticated = true
                return
            }
            catch {
                print("Error signing in: \(error)")
                isAuthenticated = false
                return
            }
        }
    }
    
    func login() {
        Task {
            do {
                let session = try await client.auth.signIn(
                    email: email,
                    password: password
                )
                
                let sessionUser = session.user
//                let userID = session.user.id
                let userEmail = session.user.email
//                let userName = session.user.userMetadata.first(where: { $0.key == "name" })?.value
//                let userAvatarURL = session.user.userMetadata.first(where: { $0.key == "avatar_url" })?.value
                
                user = genData(email: userEmail!)
                
                isAuthenticated = true
                
//                print("Sign in successful: \(session)")
            } catch {
                errorMessage = "Error signing in: \(error.localizedDescription)"
                print("Error signing in: \(error)")
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try await client.auth.signOut()
                isAuthenticated = false
                user = nil
            } catch {
                print("Error signing out: \(error)")
            }
        }
    }
    
    func genData(email: String) -> User {
        let junior: Cat = Cat(profilePicture: "junior_pfp", name: "Junior", breed: "American Shorthair", coat: "tuxedo", age: "14", sightings: [])
        let bingus: Cat = Cat(profilePicture: "bingus_pfp", name: "Bingus", breed: "British Shorthair", coat: "gray", age: "1", sightings: [])
        if email == "tumicooll@gmail.com" {
            return User(id: UUID(), username: "Sarah Threewits", profilePicture: "Sample_pfp", userLocation: "Chapel Hill, NC",
                        cats: [
                            junior,
                            bingus
                        ],
                        sightings: [
                            Sightings(timestamp: Date(), location: "Chapel Hill, NC", image: "sighting1"),
                            Sightings(identity: junior, timestamp: Date(), location: "Huntersville, NC", image: "sighting2")
                        ]
                    )
        }
        
        return User(id: UUID(), username: "Sarah Threewits", profilePicture: "Sample_pfp", userLocation: "Chapel Hill, NC",
                    cats: [
                        junior,
                        bingus
                    ],
                    sightings: [
                        Sightings(timestamp: Date(), location: "Chapel Hill, NC", image: "sighting1"),
                        Sightings(identity: junior, timestamp: Date(), location: "Huntersville, NC", image: "sighting2")
                    ]
                )
        
    }
    
    

}

#Preview {
    ContentView()
}
