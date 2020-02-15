//
//  User.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
class User{
    
    var uid: String!
    var fullname: String!
    var email: String!
    init(){}
    init(dictionary: NSDictionary){
        uid = (dictionary["uid"] as! String)
        fullname = (dictionary["fullname"] as! String)
        email = (dictionary["email"] as! String)
    }
    
    
    
}
