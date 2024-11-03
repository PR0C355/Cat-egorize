//
//  ContentView.swift
//  Cat-egorize
//
//  Created by Oluwatumininu Oguntola on 11/2/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var tabState = ""
    var body: some View {
        TabView(selection: $tabState) {
            UserProfileView()
                .tabItem {
                    Label("Home", systemImage: "person.circle")
                }
                .tag("home")

            LocalFeedView(sightings: sampleSightings)
                .tabItem {
                    Label("Local", systemImage: "map")
                }
                .tag("local")

            AddSightingView(tabState: $tabState)
                .tabItem {
                    Label("Add Sighting", systemImage: "plus.circle")
                }
                .tag("add")
                .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
}
