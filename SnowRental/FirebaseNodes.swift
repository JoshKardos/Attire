//
//  FirebaseNodes.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
class FirebaseNodes {
    
    // STORAGE
    static let storageRef = ApiKeys.firebaseRef
    
    // DATABASE
    static let designs = "designs"
    static let movieDesigns = "movie-designs"
    static let users = "users"
    static let movies = "movies"
    static let designTags = "design-tags"
    
    
    // user node
    static let uid = "uid"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let email = "email"
    static let stripeCustomerId = "stripeCustomerId"
    
    // design node
    static let imageName = "imageName"
    static let movieName = "movieName"
    static let timesUsed = "timesUsed"
    
    // movie node
    static let title = "Title"
    static let poster = "Poster"
    static let imdbID = "imdbID"
    
    // design node
    static let imageUrl = "imageUrl"
    static let designId = "designId"
    static let userId = "userId"
    static let movieId = "movieId"

}
