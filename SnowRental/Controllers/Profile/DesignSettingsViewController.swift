//
//  DesignSettingsViewController.swift
//  Flix Clothing
//
//  Created by Josh Kardos on 3/3/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class DesignSettingsViewController: UIViewController {

    var design: Design?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func blockUserPressed(_ sender: UIButton) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            ProgressHUD.showError("Not logged in")
            return
        }
        guard let uid = design?.userId else {
            ProgressHUD.showError("Reload page")
            return
        }
        UsersManager.blockUser(with: uid, currentUserId: currentUserId)

    }
    
    @IBAction func doNotShowAgainPressed(_ sender: UIButton) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            ProgressHUD.showError("Not logged in")
            return
        }
        guard let designId = design?.designId else {
            ProgressHUD.showError("Reload page")
            return
        }
        UsersManager.hidePost(with: designId, currentUserId: currentUserId)
    }
    
    @IBAction func reportPressed(_ sender: UIButton) {
        
    }
}
