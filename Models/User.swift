//
//  User.swift
//  Cat-egorize
//
//  Created by Sarah Threewits on 11/2/24.
//
import Foundation
import Supabase

struct User: Identifiable {
    let id: UUID
    var username: String
    var profilePicture: String // name of image asset
    var userLocation: String
    var cats: [Cat]
    var sightings: [Sightings] // List of sightings added from user
}
    
//    static func getUser(client: SupabaseClient, email: String = "", password: String = "") async throws -> User? {
//        var user: User? = nil
//
//    //        if let session = client.auth.session {
//    //            user = User() // Initialize with actual user data if available
//                
//    //            return user
//    //
//        
//
//        do {
//            let session = try await client.auth.session
//            
//            let sessionUser = session.user
//            let userID = session.user.id
//            let userEmail = session.user.email
//            let userName = session.user.userMetadata.first(where: { $0.key == "name" })?.value
//            let userAvatarURL = session.user.userMetadata.first(where: { $0.key == "avatar_url" })?.value
//            
//            user = User(
//                id: userID,
//                username: userEmail!,
//                profilePicture: userEmail!,
//                userLocation: "Chapel Hill, NC",
//                cats: [],
//                sightings: []
//            ) // Initialize with actual user data if available
//            
//            print(String(describing: user))
//            
//    
//            print("Sign in successful: \(session)")
//            return user
//        } catch {
//            print("No Session Found: \(error)")
//        }
//        
//        
//        do {
//            
//            let session = try await client.auth.signIn(
//                email: email,
//                password: password
//            )
//            
//            let sessionUser = session.user
//            let userID = session.user.id
//            let userEmail = session.user.email
//            let userName = session.user.userMetadata.first(where: { $0.key == "name" })?.value
//            let userAvatarURL = session.user.userMetadata.first(where: { $0.key == "avatar_url" })?.value
//            
////            let CatResponse = try await client.from("cats").select("*").eq("owningUser", value: userID).execute().value
////            let cats: [Cat] = [
////                Cat(
////                    id: CatResponse.,
////                    profilePicture: ,
////                    name: ,
////                    breed: , // optional breed information
////                    coat: , // optional coat information
////                    age: , // optional age information
////                    sightings: [:]
////                )
////                CatResponse
////            ]
//            
////            let cats = try await Cat.fetchCats(client: client, user: user)
//            
//            user = User(
//                id: userID,
//                username: userEmail!,
//                profilePicture: userEmail!,
//                userLocation: "Chapel Hill, NC",
//                cats: cats,
//                sightings: []
//            ) // Initialize with actual user data if available
//            
//            print(String(describing: user))
//    
//            print("Sign in successful: \(session)")
//            return user
//            
//        } catch {
////            errorMessage = "Error signing in: \(error.localizedDescription)"
//            print("Error signing in: \(error)")
//            throw error
//        }
//    }
//        
//        
//    }



