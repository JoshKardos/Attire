//
//  ApiKeys.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
class ApiKeys {
    
    static let firebaseRef = "gs://attire-bc3c7.appspot.com"
    static let omdbApi = "7867071f"

    static let stripePublishableTestKey = !Env.isProduction() ? "pk_test_9F0pBuyKJ1QDwXLgW3TNjf4D00PBOshx42" : "pk_live_WHXgu3eZjREb7kBIleOqy0g5008SCKK5Mf"
    static let stripeSecretTestKey = !Env.isProduction() ? "sk_test_c8WpTVTZOQnrqvqWXJJLaTeQ00whht62Tb" : "sk_live_vAf3qZEQSWvrY1rUp0FGsy5O00LIoEkEUn"
}


struct Env {

    private static let production : Bool = {
        #if DEBUG
            print("DEBUG")
            return false
        #else
            print("PRODUCTION")
            return true
        #endif
    }()

    static func isProduction () -> Bool {
        return self.production
    }
    // https://medium.com/@ant_one/determinate-the-build-configuration-at-runtime-in-swift-using-macro-6a94816bee94
}
