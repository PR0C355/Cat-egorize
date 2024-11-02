//
//  User.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import Foundation

struct User: Identifiable {
    let id = UUID()
    var username: String
    var profilePicture: String // name of image asset
    var userLocation: String
    var cats: [Cat]
    var sightings: [Sightings] // List of sightings added from user
}
