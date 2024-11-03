//
//  SightingDetailView.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import SwiftUI

struct CatSightingsView: View {
    var sightings: [Sightings]
    
    var body: some View {
        VStack(alignment: .leading) {
            if sightings.isEmpty {
                Text("No Sightings Yet.")
                    .italic()
                    .padding()
            } else {
                List {
                    ForEach(sightings, id: \.id) { sighting in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Location: \(sighting.location)")
                            
                            Text("Date: \(sighting.location)")
                            
                            Image("\(sighting.image)")
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
            }