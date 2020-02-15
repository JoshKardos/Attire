//
//  ProfileViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/13/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import ProgressHUD
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            self.configureLoggedOutProfile()
        } else {
            self.configureLoggedInProfile()
        }
    }
    
    func configureLoggedInProfile() {
        logOutButton.isHidden = false
        logOutButton.isEnabled = true
    }
    
    func configureLoggedOutProfile() {
        logOutButton.isHidden = true
        logOutButton.isEnabled = false
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            ProgressHUD.showSuccess("Logged out")
        } catch {
            print(error)
        }
    }
    
}
