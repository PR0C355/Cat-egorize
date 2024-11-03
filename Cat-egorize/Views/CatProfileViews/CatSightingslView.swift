//
//  SightingDetailView.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import SwiftUI

struct CatSightingsView: View {
    var cats: [Sightings] // Accepts an array of sightings
    
    var body: some View {
        VStack {
            Text("My claimed sighings:")
            
            if sightings.isEmpty {
                Text("No sightings yet.")
                    .padding()
            } else {
                
            }
        }
    }
    
}
