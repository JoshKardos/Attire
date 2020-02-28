//
//  ProfileViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/27/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    
    @IBOutlet weak var imageVIew: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageVIew.layer.cornerRadius = imageVIew.frame.height/2
        if let profileImageUrl = UsersManager.currentUser.profileImageUrl {
            imageVIew.kf.setImage(with: URL(string: profileImageUrl))
        } else {
            imageVIew.image = UIImage.init(systemName: "person.circle")
        }
        firstNameLabel.text = UsersManager.currentUser.firstName
        lastNameLabel.text = UsersManager.currentUser.lastName
        dateJoinedLabel.text = "Joined \(UsersManager.currentUser.dateJoinedTimestamp.toMonthDayYear())"
    }
    
    @IBAction func editPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ToEditProfile", sender: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
