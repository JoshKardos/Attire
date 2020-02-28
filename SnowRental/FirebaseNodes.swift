//
//  FirebaseNodes.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
class FirebaseNodes {
    
    // IMDB
    static let imdbID = "imdbID"
    static let title = "Title"
    static let poster = "Poster"
    
    // STORAGE
    static let storageRef = ApiKeys.firebaseRef
    
    // DATABASE
    static let designOrders = "design-orders"
    static let orders = "orders"
    static let userOrders = "user-orders"
    static let designs = "designs"
    static let movieDesigns = "movie-designs"
    static let users = "users"
    static let movies = "movies"
    static let designTags = "design-tags"
    
    // orders node
    static let orderId = "orderId"
    static let timestamp = "timestamp"
    static let userId = "userId"
    static let designId = "designId"
    static let movieId = "movieId"
    static let shirtSize = "shirtSize"
    static let price = "price"
    static let shirtColor = "shirtColor"
    static let itemsPrice = "itemsPrice"
    static let shippingHandlingPrice = "shippingHandlingPrice"
    static let beforeTaxPrice = "beforeTaxPrice"
    static let taxPrice = "taxPrice"
    static let totalPrice = "totalPrice"
    static let cardDetails = "cardDetails"
    static let shippingDetails = "shippingDetails"
    static let shippingAddressStreet = "shippingAddressStreet"
    static let shippingAddressDetails = "shippingAddressDetails"
    static let billingAddressStreet = "billingAddressStreet"
    static let billingAddressDetails = "billingAddressDetails"
    
    // users node
    static let uid = "uid"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let email = "email"
    static let stripeCustomerId = "stripeCustomerId"
    static let dateJoinedTimestamp = "dateJoinedTimestamp"
    static let profileImageUrl = "profileImageUrl"
    // design node
    static let imageName = "imageName"
    static let movieName = "movieName"
    static let timesUsed = "timesUsed"
    
    // design node
    static let imageUrl = "imageUrl"
    static let designImageUrl = "designImageUrl"
//    static let designId = "designId"
//    static let userId = "userId"
//    static let movieId = "movieId"

}
