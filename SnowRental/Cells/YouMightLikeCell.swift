//
//  YouMightLikeCell.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/14/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit

class YouMightLikeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var timesUsedLabel: UILabel!
    
    func configureCell(shirtDesign: Dictionary<String, Any>){
        imageView.image = UIImage(named: shirtDesign["imageName"] as! String)
        movieNameLabel.text = "Movies: " + (shirtDesign["movieName"] as! String)
        timesUsedLabel.text = "Used: " + String(shirtDesign["timesUsed"] as! Int)
    }
    
}
