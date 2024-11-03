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
            // Display the sighting image
            Image(sighting.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 300)
            
            Text(sighting.location)
                .font(.title2)
            
            Text("\(sighting.timestamp, formatter: dateFormatter)") // Formatting the timestamp
                .font(.title2)
                .padding()
            
            Divider()
            // Check if the cat is available and safely unwrap its properties
            VStack(alignment: .center) {
               Text("Breed: \(sighting.identity?.breed ?? "Unknown")")
               Text("Coat: \(sighting.identity?.coat ?? "Unknown")")
               Text("Age: \(sighting.identity?.age ?? "Unknown")")
            }
        }
        .navigationTitle("Sighting Detail")
        .padding()
        .background(Color(red: 10/255, green: 25/255, blue: 47/255, opacity: 0.8))    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
