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
        VStack(alignment: .center) {
            List {
                ForEach(sightings, id: \.id) { sighting in
                    VStack(alignment: .center) {
                        Image("\(sighting.image)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                        VStack(alignment: .center) {
                            Text("Location: \(sighting.location)")
                            Text("\(sighting.timestamp, formatter: dateFormatter)")
                            }
                        }
                            .padding()
                            .background(Color(red: 10/255, green: 25/255, blue: 47/255, opacity: 0.7))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
    }
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
