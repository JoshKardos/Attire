//
//  YouMightLikeCell.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/14/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


class YouMightLikeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    func configureCell(design: Design){
        imageView.kf.setImage(with: URL(string: design.imageUrl!))
        movieNameLabel.text = "Movie: \(design.movieName!)"
    }
    
}
