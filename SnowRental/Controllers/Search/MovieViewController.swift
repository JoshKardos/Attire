//
//  MovieViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/16/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class MovieViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    var movie: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        shopCollectionView.dataSource = self
        shopCollectionView.delegate = self
        MoviesManager.searchMovieFromFirebase(imdbID: movie["imdbID"]!, onSuccess: {
            MoviesManager.fetchDesignIdsFromFirebase(imdbID: self.movie["imdbID"]!, onSuccess: {
                for id in MoviesManager.movieViewingDesignIds {
                    MoviesManager.fetchDesignFromFirebase(id: id, onSuccess: {
                        if MoviesManager.movieViewingDesigns.count == MoviesManager.movieViewingDesignIds.count {
                            print(MoviesManager.movieViewingDesigns)
                            self.shopCollectionView.reloadData()
                        }
                    }, onEmpty: {
                        print("empty 3")
                    })
                }
            }, onEmpty: {
                print("empty 2")
            })
        }, onEmpty: { // on empty
            print("empty 1")
        })
    }
    
    func configureView() {
        if movie.isEmpty {
            return
        }
        movieNameLabel.text = movie["Title"]!
        let posterString = movie["Poster"]!
        if posterString == "N/A" {
            return
        }
        let url = URL(string: posterString)
        movieImageView.kf.setImage(with: url)
        
    }
}

extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2//MoviesManager.movieViewingDesigns.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopDesignCell", for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked")
    }
}

