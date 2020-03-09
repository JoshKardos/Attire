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
import Kingfisher
import WebKit

class ProfileOptionsViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var profileHeaderContainer: UIView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
        
    @IBOutlet weak var copyrightImage: UIImageView!
    
    override func viewDidLoad() {
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: UserDefaultKeys.hasClickedProfile) == nil {
            defaults.set(true, forKey: UserDefaultKeys.hasClickedProfile)
        }
        copyrightImage.image = UIImage(named: "OmdbCopyrightImage")
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        profileHeaderContainer.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureProfile()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "ToProfileViewController", sender: nil)
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
        profileHeaderContainer.alpha = 1
        if let profileImageUrl = UsersManager.currentUser.profileImageUrl {
            profileImageView.kf.setImage(with: URL(string: profileImageUrl))
        } else {
            profileImageView.image = nil
        }
        if let firstName = UsersManager.currentUser.firstName, let lastName = UsersManager.currentUser.lastName {
            profileNameLabel.text = "\(firstName) \(lastName)"
        }
        logOutButton.isHidden = false
        logOutButton.isEnabled = true
        logInButton.setTitle("Account", for: .normal)
    }
    
    func configureLoggedOutProfile() {
        profileHeaderContainer.alpha = 0
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
