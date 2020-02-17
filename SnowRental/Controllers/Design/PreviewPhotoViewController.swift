//
//  PreviewPhotoViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/16/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
class PreviewPhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction func retakePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
