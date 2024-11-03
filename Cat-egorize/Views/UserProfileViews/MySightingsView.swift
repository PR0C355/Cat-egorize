//
//  MySightingsView.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import SwiftUI

struct MySightingsView: View {
    var sightings: [Sightings] // Array of sightings
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("My Sightings")
                .font(.largeTitle)
                .padding()
            List {
                ForEach(sightings, id: \.id) { sighting in
                    VStack(alignment: .center, spacing: 5) {
                        Image("\(sighting.image)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                        
                        Text("Location: \(sighting.location)")
                        
                        Text("Date: \(sighting.timestamp)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}


