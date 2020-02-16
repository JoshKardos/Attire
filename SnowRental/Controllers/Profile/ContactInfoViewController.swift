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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = UsersManager.currentUser.email
        if Auth.auth().currentUser!.isEmailVerified {
            verifiedLabel.text = "Verified"
        } else {
            verifiedLabel.text = "Not verified"
        }
    }
    @IBAction func passwordPressed(_ sender: Any) {
        print("password pressed")
    }
}
