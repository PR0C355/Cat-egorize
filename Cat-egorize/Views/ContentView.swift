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
        let squeaks: Cat = Cat(profilePicture: "squeaks_pfp", name: "Squeaks", breed: "American Shorthair", coat: "tabby", age: "9", sightings: [])
        let joey: Cat = Cat(profilePicture: "joey_pfp", name: "Joey", breed: "Bengal", coat: "brown spotted", age: "5", sightings: [])
        let stevie: Cat = Cat(profilePicture: "stevie_pfp", name: "Stevie", breed: "Turkish van", coat: "white and orange", age: "2", sightings: [])
        let stewey: Cat = Cat(profilePicture: "stewey_pfp", name: "Stewey", breed: "American Shorthair", coat: "calico", age: "10", sightings: [])
        let stray: Cat = Cat(profilePicture: "stray1", name: "Unknown", breed: "Manx", coat: "grey and white", age: "Unknown", sightings: [])
        
        if email == "starrycat42@gmail.com" {
            return User(id: UUID(), username: "StarryCat42", profilePicture: "profile1", userLocation: "Chapel Hill, NC",
                        cats: [
                            junior,
                            bingus
                        ],
                        sightings: [
                            Sightings(identity: joey, timestamp: Date(), location: "Chapel Hill, NC", image: "joey4"),
                            Sightings(identity: stewey, timestamp: Date(), location: "Carrboro, NC", image: "stewey2"),
                            Sightings(identity: stevie, timestamp: Date(), location: "Chapel Hill, NC", image: "stevie3")                        ]
            )
        }
        
        
        if email == "NebulaHunter@gmail.com" {
            return User(id: UUID(), username: "NebulaHunter", profilePicture: "profile2", userLocation: "Chapel Hill, NC",
                        cats: [
                            
                            stevie
                        ],
                        sightings: [
                            Sightings(identity: squeaks, timestamp: Date(), location: "Carrboro, NC", image: "squeaks3"),
                            Sightings(identity: junior, timestamp: Date(), location: "Huntersville, NC", image: "junior3")
                        ]
            )
        }
        
        
        
        if email == "astrowhiskers@gmail.com" {
            return User(id: UUID(), username: "AstroWhiskers", profilePicture: "profile3", userLocation: "Chapel Hill, NC",
                        cats: [
                            joey
                        ],
                        sightings: [
                            Sightings(timestamp: Date(), location: "Chapel Hill, NC", image: "stray2"),
                            Sightings(identity: stevie, timestamp: Date(), location: "Chapel Hill, NC", image: "stevie2")
                        ]
            )
        }
        
        
        if email == "cosmicpaws@gmail.com" {
            return User(id: UUID(), username: "CosmicPaws", profilePicture: "profile4", userLocation: "Chapel Hill, NC",
                        cats: [
                            stewey
                        ],
                        sightings: [
                            Sightings(identity: joey, timestamp: Date(), location: "Chapel Hill, NC", image: "joey2"),
                            Sightings(identity: squeaks, timestamp: Date(), location: "Huntersville, NC", image: "squeaks2")
                        ]
            )
        }
        
        
        
        if email == "galactictail@gmail.com" {
            return User(id: UUID(), username: "GalacticTail", profilePicture: "profile5", userLocation: "Carrboro, NC",
                        cats: [
                            squeaks
                        ],
                        sightings: [
                            Sightings(identity: stevie, timestamp: Date(), location: "Chapel Hill, NC", image: "stevie2"),
                            Sightings(identity: junior, timestamp: Date(), location: "Chapel Hill, NC", image: "junior2")
                        ]
            )
        }
        
        return User(id: UUID(), username: "GalacticTail", profilePicture: "profile5", userLocation: "Chapel Hill, NC",
                    cats: [
                        squeaks
                    ],
                    sightings: [
                        Sightings(identity: stevie, timestamp: Date(), location: "Chapel Hill, NC", image: "stevie2"),
                        Sightings(identity: junior, timestamp: Date(), location: "Chapel Hill, NC", image: "junior2")
                    ]
        )
    }
}

#Preview {
    ContentView()
}
