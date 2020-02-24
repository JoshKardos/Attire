//
//  ContactInfoViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

class ContactInfoViewController: UIViewController {

    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var verifiedLabel: UILabel!
    @IBOutlet weak var passwordContainer: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLabel.text = UsersManager.currentUser.email
        if Auth.auth().currentUser!.isEmailVerified {
            verifiedLabel.text = "Verified"
            verifiedLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else {
            verifiedLabel.text = "Not verified"
            verifiedLabel.textColor = UIColor.red
        }
    }
}
