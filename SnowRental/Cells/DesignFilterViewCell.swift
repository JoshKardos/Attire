//
//  DesignFilterViewCell.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/17/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit

class DesignFilterViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var cellIndex: Int!
 
    func configureCell(image input: UIImage, filter: FiltersManager.Filter, index: Int) {
        self.label.text = filter.nickName
        DispatchQueue.global(qos: .userInteractive).async {
            let filteredImage = FiltersManager.applyFilterTo(image: input, filterEffect: filter, filterIntensity: nil)//FiltersManager.applyFilter(input, filterName, intensity: 1)
            DispatchQueue.main.async {
                self.imageView.image = filteredImage
            }
        }
    }
    
    
}
