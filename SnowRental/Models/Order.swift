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
    
    init(design: Design, movie: [String: String], shirtColor: UIColor, imageUrl: URL, price: Int, size: String, userId: String){
        self.design = design
        self.movie = movie
        self.shirtColor = shirtColor
        self.imageURL = imageUrl
        self.price = price
        self.size = size
        self.userId = userId
    }
    
}
