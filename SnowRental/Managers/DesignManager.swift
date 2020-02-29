//
//  ShopManager.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/16/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class DesignManager {
    static var imageFromLibrary: UIImage?
    static var suggestedDesigns: [Design]?
    
    static func fetchSuggestedDesigns(onSuccess: @escaping() -> Void, onError: @escaping() -> Void) {
        Database.database().reference().child(FirebaseNodes.designs).queryLimited(toLast: 4).observe(.value) { (snapshot) in
            if !snapshot.exists() {
                onError()
                return
            }
            suggestedDesigns = []
            let designsMap = snapshot.value as! [String: [String: String]]
            for (_, d) in designsMap {
                let design = Design(dictionary: d)
                print(design)
                suggestedDesigns!.append(design)
            }
            print(suggestedDesigns?.count)
            onSuccess()
        }
    }
}
