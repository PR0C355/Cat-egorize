//
//  HomePage.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import SwiftUI

let sampleSightings = [
    Sightings(timestamp: Date(), location: "Chapel Hill, NC", image: "junior2"),
    Sightings(timestamp: Date(), location: "Huntersville, NC", image: "stevie2")
]

struct UserProfileView: View {
    
    // color preferences
    init(user: User) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Set a dark, space-themed background color
        appearance.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 30/255, alpha: 1) // Dark navy color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Title text color
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Large title text color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        self.user = user
    }
    
    // Tracks selected view ("My Cats" or "My Sightings")
    @State private var selectedView: String = "My Cats"
    
    @State var user: User
    
//    @State var user = User(username: "Example_User", profilePicture: "Sample_pfp", userLocation: "Chapel Hill, NC", cats: [
//        Cat(profilePicture: "junior_pfp", name: "Junior", breed: "American Shorthair", coat: "gray", age: "14", sightings: []),
//        Cat(profilePicture: "bingus_pfp", name: "Bingus", breed: "British Shorthair", coat: "tuxedo", age: "1", sightings: [])],
//        sightings: [
//            Sightings(timestamp: Date(), location: "Chapel Hill, NC", image: "sighting1"),
//            Sightings(identity: Cat(profilePicture: "junior_pfp", name: "Junior", breed: "American Shorthair", coat: "tuxedo", age: "14", sightings: []), timestamp: Date(), location: "Huntersville, NC", image: "sighting2")]
//    )
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("My Profile")
                    .font(.title)
                    .padding(.bottom, 5)
                    .padding(.horizontal, 15)
                
                HStack(alignment: .top, spacing: 15) {
                    // Profile Picture
                    Image(user.profilePicture)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .scaledToFit()
                        .padding(.bottom, 5)
                        .padding(.horizontal, 15)
                    
                    // User info
                    VStack(alignment: .leading, spacing: 15) {
                        Text(user.username)
                            .font(.title2)
                        Text(user.userLocation)
                            .font(.subheadline)
                            .padding(.horizontal, 5)
                    }
                    .padding([.top, .trailing], 15)
                }

            Divider()
                .padding(.vertical, 5)
            
            // Buttons to switch between "My Cats" and "My Sightings"
            HStack(alignment: .center) {
                Button(action: {
                    selectedView = "My Cats"
                }) {
                    Label("My Cats", systemImage: "pawprint")
                        .padding()
                        .background(selectedView == "My Cats" ? Color.blue : Color.clear)
                        .foregroundColor(selectedView == "My Cats" ? .white : .blue)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                
                Button(action: {
                    selectedView = "My Sightings"
                }) {
                    Label("My Sightings", systemImage: "eye")
                        .padding()
                        .background(selectedView == "My Sightings" ? Color.blue : Color.clear)
                        .foregroundColor(selectedView == "My Sightings" ? .white : .blue)
                        .cornerRadius(8)
                        .padding(.horizontal,20)
                }
            }
            .padding(.bottom, 8)
            
            // Display selected view
            if selectedView == "My Cats" {
                MyCatsView(cats: user.cats)
                    .transition(.opacity)
            } else {
                MySightingsView(sightings: user.sightings)
                    .transition(.opacity)
            }
            
            Spacer()
        }
    }
    
    
}
