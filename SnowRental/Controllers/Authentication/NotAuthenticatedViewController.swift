//
//  NotAuthenticatedViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/14/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit

class NotAuthenticatedViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.borderColor = #colorLiteral(red: 1, green: 0.2002071162, blue: 0.02745098039, alpha: 1)
        logInButton.layer.borderWidth = 1
        
        //make nav bar translucent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
