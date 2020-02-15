//
//  ProfileViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/13/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
    }
    
}
