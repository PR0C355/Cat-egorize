//
//  ContentView.swift
//  Cat-egorize
//
//  Created by Oluwatumininu Oguntola on 11/2/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Set a dark, space-themed background color
        appearance.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 30/255, alpha: 1) // Dark navy color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Title text color
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Large title text color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }


    @State private var tabState = ""
    var body: some View {
        TabView(selection: $tabState) {
            UserProfileView()
                .tabItem {
                    Label("Home", systemImage: "person.circle")
                }
                .tag("home")
            
            AddSightingView(tabState: $tabState)
                .tabItem {
                    Label("Add Sighting", systemImage: "plus.circle")
                }
                .tag("add")
                .toolbar(.hidden, for: .tabBar)
            
            LocalFeedView(sightings: sampleSightings)
                .tabItem {
                    Label("Local", systemImage: "map")
                }
                .tag("local")
        }
    }
}

#Preview {
    ContentView()
}
