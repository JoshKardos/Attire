//
//  MoviesManager.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import FirebaseDatabase
class MoviesManager {
    static var movies: Dictionary<String, Any> = [:]
    static func fetchMovies(completion: @escaping() -> Void) {
        Database.database().reference().child("Goodfellas").observe(.value) { (snapshot) in
            self.movies[snapshot.key] = snapshot.value!
            completion()
        }
    }
}
