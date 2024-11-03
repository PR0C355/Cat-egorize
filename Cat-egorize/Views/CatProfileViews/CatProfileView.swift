//
//  CatProfileView.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import SwiftUI

struct CatProfileView: View {
    var cat: Cat
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // cat's name taken care of by navigation title
                    
                    // cat's pfp
                    Image(cat.profilePicture)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .padding()
                        .shadow(color: Color.white.opacity(0.4), radius: 18)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        // optional breed
                        let breed = cat.breed!
                        Text("Breed: \(breed)")
                            .font(.title2)
                        
                        // optional coat
                        let coat = cat.coat!
                        Text("Coat: \(coat)")
                            .font(.title2)
                        
                        // optional age
                        let age = cat.age!
                        Text("Approximate Age: \(age) years")
                            .font(.title2)
                    }
                    
                    Divider()
                    // navigation to cats sightings
                    .padding()
                    NavigationLink(destination: CatSightingsView(sightings: cat.sightings!)) {
                        Text("[\(cat.name)'s Sightings]")
                            .navigationTitle("\(cat.name)'s Profile")
                            .accentColor(.black)
                            .fontWeight(.semibold)
                            .shadow(color: Color.white.opacity(2), radius: 6)
                    }
                }
            }
            .background(Color(red: 15/255, green: 25/255, blue: 47/255, opacity: 0.6))
        }
    }
}
