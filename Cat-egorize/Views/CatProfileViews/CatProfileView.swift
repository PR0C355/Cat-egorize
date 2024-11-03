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
        ScrollView {
            VStack(alignment: .leading) {
                // cat's name taken care of by navigation title
                
                // cat's pfp
                Image(cat.profilePicture)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                
                // optional breed
                let breed = cat.breed!
                Text("Breed: \(breed)")
                    .font(.title2)
                
                // optional age
                let age = cat.age!
                Text("Approximate Age: \(age) years")
                    .font(.title2)
                
                //
                Text("My Claimed Sightings:")
                    .font(.headline)
                    .padding(.top)
            }
            .navigationTitle("\(cat.name)'s Profile")
        }
    }
}
