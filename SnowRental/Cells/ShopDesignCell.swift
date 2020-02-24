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
    
    @IBOutlet weak var designImageView: UIImageView!
    
    func configureCell(design: Design) {
        guard let designUrl = design.imageUrl else {
            return
        }
        let url = URL(string: designUrl)
        designImageView.kf.setImage(with: url)
    }
}
