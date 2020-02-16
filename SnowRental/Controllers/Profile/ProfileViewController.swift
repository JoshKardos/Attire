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
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureProfile()
        self.navigationController?.navigationBar.isHidden = true

    }
    @IBAction func logInPressed(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            // button is "Log in or Sign up"
            self.performSegue(withIdentifier: "toAuthentication", sender: nil)
        } else {
            // button is "Account"
            self.performSegue(withIdentifier: "toAccount", sender: nil)
        }
    }
    
    func configureProfile() {
        if Auth.auth().currentUser == nil {
            self.configureLoggedOutProfile()
        } else {
            self.configureLoggedInProfile()
        }
    }
    
    func configureLoggedInProfile() {
        logOutButton.isHidden = false
        logOutButton.isEnabled = true
        logInButton.setTitle("Account", for: .normal)
    }
    
    func configureLoggedOutProfile() {
        logOutButton.isHidden = true
        logOutButton.isEnabled = false
        logInButton.setTitle("Log in or Sign up", for: .normal)

    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        UsersManager.logOut(onSuccess: {
            self.configureProfile()
        })
    }
    
}
