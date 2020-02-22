//
//  ShopDesignCell.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/16/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit

class ShopDesignCell: UICollectionViewCell {
    
    @IBOutlet weak var designImage: UIImageView!
    
    func configureCell(design: [String: String]) {
        guard let designUrl = design[FirebaseNodes.imageUrl] else {
            return
        }
        let url = URL(string: designUrl)
        designImage.kf.setImage(with: url)
    }
}
