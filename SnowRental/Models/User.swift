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
    var firstName: String!
    var lastName: String!
    var email: String!
    var stripeCustomerId: String?
    
    init(){}
    init(dictionary: NSDictionary){
        uid = (dictionary[FirebaseNodes.uid] as! String)
        firstName = (dictionary[FirebaseNodes.firstName] as! String)
        lastName = (dictionary[FirebaseNodes.lastName] as! String)
        email = (dictionary[FirebaseNodes.email] as! String)
        
        if let stripeId = dictionary[FirebaseNodes.stripeCustomerId] as? String {
            stripeCustomerId = stripeId
        }
    }
    
    func setStripeCustomerId(id: String) {
        self.stripeCustomerId = id
    }
}
