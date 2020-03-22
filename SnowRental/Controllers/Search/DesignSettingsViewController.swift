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
        UsersManager.blockUser(with: uid, currentUserId: currentUserId) {
            UsersManager.blockUserEnabled = true
            self.navigationController?.popToRootViewController(animated: false)
        }

    }
    
    @IBAction func doNotShowAgainPressed(_ sender: UIButton) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            ProgressHUD.showError("Not logged in")
            return
        }
        guard let design = design else {
            ProgressHUD.showError("Reload page")
            return
        }
        UsersManager.hidePost(with: design, currentUserId: currentUserId) {
            UsersManager.hidePostEnabled = true
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    @IBAction func reportPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you want to continue?", message: "Are you sure you want to report this design?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.reportHelper()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func reportHelper() {
        MyAPIClient.emailReport(design: self.design!) {
            ProgressHUD.showSuccess("Reported design")
        }
    }
}
