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
    @IBOutlet weak var designLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noDesignsLabel: UILabel!
    
    var movie: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        shopCollectionView.dataSource = self
        shopCollectionView.delegate = self
        MoviesManager.fetchDesignIdsFromFirebase(imdbID: self.movie["imdbID"]!, onSuccess: {
            for id in MoviesManager.movieViewingDesignIds {
                MoviesManager.fetchDesignFromFirebase(id: id, onSuccess: {
                    if MoviesManager.movieViewingDesigns.count == MoviesManager.movieViewingDesignIds.count {
                        self.designLoadingIndicator.stopAnimating()
                        self.shopCollectionView.reloadData()
                    }
                }, onEmpty: {
                    self.designLoadingIndicator.stopAnimating()
                    print("empty 2")
                })
            }
        }, onEmpty: {
            //no designs
            self.designLoadingIndicator.stopAnimating()
            self.noDesignsLabel.isHidden = false
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
        return MoviesManager.movieViewingDesigns.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopDesignCell", for: indexPath) as! ShopDesignCell
        cell.configureCell(design: MoviesManager.movieViewingDesigns[indexPath.row] as! [String : String])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked")
    }
}
