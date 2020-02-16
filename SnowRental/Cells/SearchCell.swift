//
//  SearchCell.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/16/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(movie: [String: String]) {
        titleLabel.text = movie["Title"]
        let posterString = movie["Poster"]!
        if posterString == "N/A" {
            return
        }
        let url = URL(string: posterString)
        movieImageView.kf.setImage(with: url)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
