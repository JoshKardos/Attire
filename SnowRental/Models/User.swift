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
    var dateJoinedTimestamp: String!
    var profileImageUrl: String?
    var stripeCustomerId: String?
    var blockedUserIds: [String]?
    var hiddenDesignIds: [String]?
    
    init(){}
    init(dictionary: NSDictionary){
        self.uid = (dictionary[FirebaseNodes.uid] as! String)
        self.firstName = (dictionary[FirebaseNodes.firstName] as! String)
        self.lastName = (dictionary[FirebaseNodes.lastName] as! String)
        self.email = (dictionary[FirebaseNodes.email] as! String)
        self.dateJoinedTimestamp = (dictionary[FirebaseNodes.dateJoinedTimestamp] as! String)
        if let stripeId = dictionary[FirebaseNodes.stripeCustomerId] as? String {
            self.stripeCustomerId = stripeId
        }
        if let profileImageUrl = dictionary[FirebaseNodes.profileImageUrl] as? String {
            self.profileImageUrl = profileImageUrl
        }
    }
    
    func setStripeCustomerId(id: String) {
        self.stripeCustomerId = id
    }
    
    func setBlockedUsersArr(userIds: [String]) {
        self.blockedUserIds = userIds
    }
    
    func setHiddenDesignIds(designIds: [String]) {
        self.hiddenDesignIds = designIds
    }
}
