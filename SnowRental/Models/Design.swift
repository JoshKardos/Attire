//
//  Design.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/22/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
class Design {
    
    var designId: String?
    var imageUrl: String?
    var movieId: String?
    var userId: String?
    var price = 4000
    var movieName: String?
    
    init(dictionary: [String : String]) {
        designId = dictionary[FirebaseNodes.designId]
        imageUrl = dictionary[FirebaseNodes.imageUrl]
        movieId = dictionary[FirebaseNodes.movieId]
        userId = dictionary[FirebaseNodes.userId]
        movieName = dictionary[FirebaseNodes.movieName]
    }
    
    func isBlockedOrHiddenByCurrentUser() -> Bool {
        if let blockedUserIds = UsersManager.currentUser.blockedUserIds {
            if blockedUserIds.contains(self.userId!) {
                return true
            }
        }
        if let hiddenDesignIds = UsersManager.currentUser.hiddenDesignIds {
            if hiddenDesignIds.contains(self.designId!) {
                return true
            }
        }
        return false
        
    }
}
