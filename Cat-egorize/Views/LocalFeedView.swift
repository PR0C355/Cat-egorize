//
//  LocalFeedView.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import SwiftUI

struct LocalFeedView: View {
    @State var sightings: [Sightings] // Assuming Sightings is your model

    var body: some View {
        NavigationView {
            List(sightings) { sighting in
                NavigationLink(destination: LocalCatView(sighting: sighting)) {
                    HStack {
                        Image(sighting.image) // Assuming each sighting has an image property
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        VStack(alignment: .leading) {
                            Text(sighting.location)
                                .font(.headline)
                            Text("\(sighting.timestamp, formatter: dateFormatter)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Local Feed")
        }
    }
}

// Date Formatter for displaying the timestamp
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

