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
                                .frame(width: 150, height: 150)
                            Text(cat.name)
                                .font(.title)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal)
                .background(Color(red: 10/255, green: 25/255, blue: 47/255, opacity: 0.8))
            }
            
            // Sheet presentation tied to selectedCat state
            .sheet(item: $selectedCat) { cat in
                CatProfileView(cat: cat)
                    .edgesIgnoringSafeArea(.all) // Makes the sheet full screen
            }
        }
    }
}


