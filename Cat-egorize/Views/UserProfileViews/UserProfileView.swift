//
//  HomePage.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import SwiftUI

struct UserProfileView: View {
    
    @State var user = User(username: "Example_User", profilePicture: "Sample_pfp", userLocation: "Chapel Hill, NC", cats: [
        Cat(profilePicture: "junior_pfp", name: "Junior", breed: "American Shorthair", age: 14, sightings: []),
        Cat(profilePicture: "bingus_pfp", name: "Bingus", breed: "British Shorthair", age: 1, sightings: []),
    ],
                           sightings: []
    )
    @State var sightings = Sightings(timestamp: Date(), location: "Chapel Hill, NC", image: "junior_pfp")
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    // Profile Picture
                    Image(user.profilePicture)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding()
                    
                    // User info
                    VStack {
                        Text(user.username)
                            .font(.title2)
                        Text(user.userLocation)
                            .font(.title3)
                            .padding()
                    }
                }
                Divider()
                    .padding(.vertical)
                
                // Nested tab view for "my cats" and "my sightings"
                TabView {
                    MyCatsView(cats: user.cats)
                        .tabItem {
                            Label("My Cats", systemImage: "pawprint")
                        }
                    MySightingsView(sightings: user.sightings)
                        .tabItem {
                            Label("My Sightings", systemImage: "eye")
                        }
                }
                .frame(height: 400)
                
                Spacer()
                
            }
            .navigationTitle("Profile")
        }
    }
}
extension DateFormatter {
    static var shortDateAndTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}
