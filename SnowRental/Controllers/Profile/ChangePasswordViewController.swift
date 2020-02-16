//
//  ChangePasswordViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import ProgressHUD
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTextFields()
    }
    
    func setTextFields() {
        oldPasswordTextField.becomeFirstResponder()
        newPasswordTextField.becomeFirstResponder()
        confirmPasswordTextField.becomeFirstResponder()
        
        oldPasswordTextField.borderStyle = .none
        newPasswordTextField.borderStyle = .none
        confirmPasswordTextField.borderStyle = .none
    }
    @IBAction func savePressed(_ sender: Any) {
        //compare new passwords agaisnt eachother
        if newPasswordTextField.text != confirmPasswordTextField.text {
            ProgressHUD.showError("The new password fields are different...")
            return
        }
        
        let emailString = (Auth.auth().currentUser?.email)!
        let passwordString = oldPasswordTextField.text!
        
        ProgressHUD.show()
        UsersManager.reauthenticateUser(email: emailString, password: passwordString, onSuccess: {
            Auth.auth().currentUser?.updatePassword(to: self.newPasswordTextField.text!) { (error) in
                if error != nil{
                    print("Error changing password")
                    ProgressHUD.showError("\((error?.localizedDescription)!)")
                    return
                }
                ProgressHUD.showSuccess("Password changed")
                return
            }
        }) { error in
            ProgressHUD.showError(error)
        }
    }
}
