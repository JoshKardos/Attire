//
//  MoviesManager.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Alamofire
import SwiftyJSON

class MoviesManager {
    static var movies: Dictionary<String, Any> = [:]
    static var omdbSearchMovies: [Any] = []

    static let omdbBaseUrl = "http://www.omdbapi.com/?apikey=\(ApiKeys.omdbApi)"

    static func searchMovie(title: String, onSuccess: @escaping() -> Void ) {
        let titleUrl = title.replacingOccurrences(of: " ", with: "+")
        AF.request("\(omdbBaseUrl)&s=\(titleUrl)", method: .get).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                // Do whatever here
                print("failure")
                return

            case .success(let data):
                let dataObject = data as! [String: Any]
                if dataObject["Error"] != nil {
                    print(dataObject["Error"] as Any)
                    return
                }
                if dataObject["Response"] != nil {
                    omdbSearchMovies = dataObject["Search"] as! [Any]
                    onSuccess()
                    return
                }
                return
            }
        }
    }
    
    static func fetchMovies(completion: @escaping() -> Void) {
//        Database.database().reference().child("Goodfellas").observe(.value) { (snapshot) in
//            self.movies[snapshot.key] = snapshot.value!
//            completion()
//        }
        
//        Alamofire.request(omdbBaseUrl, method: .get)
//            .responseJSON { response in
//                if response.result.isSuccess {
//                    let bitcoinJSON : JSON = JSON(response.result.value!)
//                    self.updateBitcoinData(json: bitcoinJSON)
//                    ProgressHUD.showSuccess("Bitcoin data updated")
//
//                } else {
//                    self.bitcoinPriceLabel.text = "Connection Issues"
//                    ProgressHUD.showError("Error fetching bitcoin data")
//                }
//        }
//        AF.request(omdbBaseUrl, method: .get).responseJSON { (response) in
//            print("**** \(response)")
//        }
    }
}
