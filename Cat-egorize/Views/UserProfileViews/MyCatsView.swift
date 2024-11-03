//
//  MyCatsView.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import SwiftUI

struct MyCatsView: View {
    var cats: [Cat]
    
    @State private var selectedCat: Cat? // cat that fills in the sheet
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                List(cats) { cat in
                    Button(action: {
                        selectedCat = cat
                    }) {
                        HStack {
                            Image(cat.profilePicture)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            Text(cat.name)
                                .font(.title)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            // Sheet presentation tied to selectedCat state
            .sheet(item: $selectedCat) { cat in
                CatProfileView(cat: cat)
                    .edgesIgnoringSafeArea(.all) // Makes the sheet full screen
            }
        }
    }
}


