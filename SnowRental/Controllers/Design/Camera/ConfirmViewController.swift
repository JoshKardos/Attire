//
//  ConfirmViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/17/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import TaggerKit

class ConfirmViewController: UIViewController {

    var image: UIImage?
    var tags: [String]?
    var movie: [String: String]?
    
    @IBOutlet weak var designImageView: UIImageView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var tagsView: UIView!
    
    var tagsCollection = TKCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designImageView.image = image
        guard let movie = movie else {
            return
        }
        movieNameLabel.text = movie["Title"]!
        let posterString = movie["Poster"]!
        if posterString == "N/A" {
            return
        }
        
        if let _ = tags {
            add(tagsCollection, toView: tagsView)
            tagsCollection.tags = tags!
        }

        let url = URL(string: posterString)
        movieImageView.kf.setImage(with: url)
    }

}
