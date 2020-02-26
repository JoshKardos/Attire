//
//  OrderCell.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/25/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import Kingfisher
class OrderCell: UITableViewCell {

    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var designIdLabel: UILabel!
    @IBOutlet weak var orderImageView: UIImageView!
    
    
    func configureCell(order: Order) {
        movieLabel.text = "Movie: \(order.design!.movieName!)"
        designIdLabel.text = "Design id: \(order.designId!)"
        orderImageView.kf.setImage(with: order.imageURL)
    }
}
