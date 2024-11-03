//
//  AddSightingView.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import SwiftUI

struct AddSightingView: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var imagePickerIsPresenting: Bool = false
    @State private var uiImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var sightingLocation: String = ""
    @State private var sightingDate: Date = Date()
    
    @Binding var tabState: String

    var body: some View {
        NavigationView {
            VStack {
                // Navigation bar with back button
                Button("Baack to Home"){
                    tabState = "home"
                }
                
                Text("Add a Sighting")
                    .font(.largeTitle)
                    .padding()

                // Buttons to select image source
                HStack {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .onTapGesture {
                            sourceType = .photoLibrary
                            imagePickerIsPresenting = true
                        }
                    
                    Image(systemName: "camera")
                        .font(.largeTitle)
                        .onTapGesture {
                            sourceType = .camera
                            imagePickerIsPresenting = true
                        }
                }
                .padding()

                // Display selected image
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(10)
                        .padding()
                } else {
                    Rectangle()
                        .strokeBorder()
                        .foregroundColor(.gray)
                        .frame(height: 250)
                        .cornerRadius(10)
                        .padding()
                }

                // Text field for location input
                TextField("Enter Location", text: $sightingLocation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Date picker for sighting date
                DatePicker("Sighting Date", selection: $sightingDate, displayedComponents: .date)
                    .padding()

                // Button to submit the sighting (you can implement the logic to save the sighting)
                Button(action: {
                    // Logic to save the sighting, using uiImage, sightingLocation, and sightingDate
                    print("Sighting added with location: \(sightingLocation), date: \(sightingDate)")
                }) {
                    Text("Add Sighting")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                Spacer()
            }
            .sheet(isPresented: $imagePickerIsPresenting) {
                ImagePicker(uiImage: $uiImage, isPresenting: $imagePickerIsPresenting, sourceType: $sourceType)
            }
        }
    }
}
