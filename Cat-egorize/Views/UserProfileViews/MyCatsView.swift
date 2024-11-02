//
//  MyCatsView.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import SwiftUI

struct MyCatsView: View {
    var cats: [Cat] // Accepts an array of cats
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // lists all users cats
                List(cats) { cat in
                    NavigationLink(destination: CatProfileView(cat: cat)) {
                        HStack {
                            Image(cat.profilePicture)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                            Text(cat.name)
                                .font(.title)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("My Cats")
        }
    }
}
