//
//  Cat.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import Foundation

struct Cat: Identifiable {
    let id = UUID()
    let profilePicture: String // name of image asset *subject for change
    let name: String
    let breed: String? // optional breed information
    let coat: String? // optional coat information
    let age: String? // optional age information
    var sightings: [Sightings]? // List of sightings attached to cat
}
