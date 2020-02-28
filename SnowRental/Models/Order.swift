//
//  Order.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/23/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit

class Order {
    var design: Design?
    var movie: [String: String]?
    var shirtColor: UIColor?
    var imageURL: URL?
    var price: Int?
    var size: String?
    var userId: String?
    var id: String?
    var designId: String?
    var movieId: String?
    var shirtHex: String?
    var timestamp: String?
    var orderId: String?
    
    var itemsPrice: String?
   var shippingHandlingPrice: String?
   var beforeTaxPrice: String?
   var taxPrice: String?
   var totalPrice: String?
   var cardDetails: String?
   var shippingDetails: String?
   var shippingAddressStreet: String?
   var shippingAddressDetails: String?
    var billingAddressStreet: String?
    var billingAddressDetails: String?
    
    init(design: Design, movie: [String: String], shirtColor: UIColor, imageUrl: URL, price: Int, size: String, userId: String){
        self.design = design
        self.movie = movie
        self.shirtColor = shirtColor
        self.imageURL = imageUrl
        self.price = price
        self.size = size
        self.userId = userId
    }
    
    init(dict: [String : Any]) {
        guard let designId = dict[FirebaseNodes.designId] as? String,
            let movieId = dict[FirebaseNodes.movieId] as? String,
            let orderId = dict[FirebaseNodes.orderId] as? String,
            let price = dict[FirebaseNodes.price] as? String,
            let shirtHex = dict[FirebaseNodes.shirtColor] as? String,
            let shirtSize = dict[FirebaseNodes.shirtSize] as? String,
            let timestamp = dict[FirebaseNodes.timestamp] as? String,
            let userId = dict[FirebaseNodes.userId] as? String,
            let designUrl = dict[FirebaseNodes.designImageUrl] as? String,
            let itemsPrice = dict[FirebaseNodes.itemsPrice] as? String,
            let shippingHandlingPrice = dict[FirebaseNodes.shippingHandlingPrice] as? String,
            let beforeTaxPrice = dict[FirebaseNodes.beforeTaxPrice] as? String,
            let taxPrice = dict[FirebaseNodes.taxPrice] as? String,
            let totalPrice = dict[FirebaseNodes.totalPrice] as? String,
            let cardDetails = dict[FirebaseNodes.cardDetails] as? String,
            let shippingDetails = dict[FirebaseNodes.shippingDetails] as? String,
            let shippingAddressStreet = dict[FirebaseNodes.shippingAddressStreet] as? String,
            let shippingAddressDetails = dict[FirebaseNodes.shippingAddressDetails] as? String,
            let billingAddressStreet = dict[FirebaseNodes.billingAddressStreet] as? String,
            let billingAddressDetails = dict[FirebaseNodes.billingAddressDetails] as? String
            else {
            print("ERROR WITH THIS DICT \n \(dict)")
            print("missing order variable")
            return
        }
        self.imageURL = URL(string: designUrl)
        self.designId = designId
        self.movieId = movieId
        self.shirtHex = shirtHex
        self.price = Int(price)
        self.size = shirtSize
        self.userId = userId
        self.timestamp = timestamp
        self.orderId = orderId
        
        self.itemsPrice = itemsPrice
        self.shippingHandlingPrice = shippingHandlingPrice
        self.beforeTaxPrice = beforeTaxPrice
        self.taxPrice = taxPrice
        self.totalPrice = totalPrice
        self.cardDetails = cardDetails
        self.shippingDetails = shippingDetails
        self.shippingAddressStreet = shippingAddressStreet
        self.shippingAddressDetails = shippingAddressDetails
        self.billingAddressDetails = billingAddressDetails
        self.billingAddressStreet = billingAddressStreet
    }
    
}
