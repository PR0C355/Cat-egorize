//
//  LocalCatView.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import SwiftUI

struct LocalCatView: View {
    var sighting: Sightings // The selected sighting
    
    var body: some View {
        VStack {
            Image(sighting.image) // Display the sighting image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 300)
            
            Text(sighting.location)
                .font(.largeTitle)
                .padding()
            
            Text("\(sighting.timestamp)")
                .font(.subheadline)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Sighting Detail")
        .padding()
    }
}
