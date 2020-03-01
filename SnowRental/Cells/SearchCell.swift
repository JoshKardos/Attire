//
//  SearchCell.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/16/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(movie: [String: String]) {
        titleLabel.text = movie[FirebaseNodes.title]
        let posterString = movie[FirebaseNodes.poster]!
        if posterString == "N/A" {
            movieImageView.image = UIImage(named: "camera")
            return
        }
        let url = URL(string: posterString)
        movieImageView.kf.setImage(with: url)
    }
    
}
