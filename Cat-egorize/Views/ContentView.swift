//
//  ContentView.swift
//  Cat-egorize
//
//  Created by Oluwatumininu Oguntola on 11/2/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            UserProfileView()
                .tabItem {
                    Label("Home", systemImage: "person.circle")
                }

            LocalFeedView(sightings: sampleSightings)
                .tabItem {
                    Label("Local", systemImage: "map")
                }

            AddSightingView()
                .tabItem {
                    Label("Add Sighting", systemImage: "plus.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
