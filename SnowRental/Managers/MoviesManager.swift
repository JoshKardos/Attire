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
    static var movieViewingDesignIds: [String] = []
    static var movieViewingDesigns: [Design] = []
    static let omdbBaseUrl = "http://www.omdbapi.com/?apikey=\(ApiKeys.omdbApi)"
    
    static func fetchDesignFromFirebase(id: String, onSuccess: @escaping() -> Void, onEmpty: @escaping() -> Void) {
        Database.database().reference().child(FirebaseNodes.designs).child(id).observe(.value) { (snapshot) in
            if !snapshot.exists() {
                onEmpty()
                return
            }
            let design = Design(dictionary: snapshot.value as! [String: String])
            movieViewingDesigns.append(design)
            onSuccess()
        }
    }
    
    static func fetchDesignIdsFromFirebase(imdbID: String, onSuccess: @escaping() -> Void, onEmpty: @escaping() -> Void) {
        Database.database().reference().child(FirebaseNodes.movieDesigns).child(imdbID).observe(.value) { (snapshot) in
            if !snapshot.exists() {
                onEmpty()
                return
            }
            let designsMap = snapshot.value as! [String: Any]
            let designsIds = designsMap.keys
            movieViewingDesignIds = Array(designsIds)
            onSuccess()
        }
    }
    
    static func clearMovieDesigns() {
        movieViewingDesignIds = []
        movieViewingDesigns = []
    }
    
    static func searchMovieFromFirebase(imdbID: String, onSuccess: @escaping() -> Void, onEmpty: @escaping() -> Void) {
        Database.database().reference().child(FirebaseNodes.movies).child(imdbID).observe(.value) { (snapshot) in
            if !snapshot.exists() {
                onEmpty()
                return
            }
            onSuccess()
        }
    }
    
    static func fetchMovieFromOMDB(id: String, completion: @escaping ([String: Any]) -> Void) {
        
        AF.request("\(omdbBaseUrl)&i=\(id)", method: .get).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                // Do whatever here
                print("failure")
                return

            case .success(let data as [String: Any]):
                completion(data)
                return
            default:
               fatalError("received non-dictionary JSON response")
            
            }
        }
    }

    static func searchMovieFromOMDB(title: String, onSuccess: @escaping() -> Void) {
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
    
}
