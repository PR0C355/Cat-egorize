//
//  Sighting.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import Foundation

struct Sightings: Identifiable {
    let id = UUID()
    var timestamp: Date // date and time of the sighting
    var location: String //location of sighting
    var image: String // name of image asset/URL for the sighting
}
