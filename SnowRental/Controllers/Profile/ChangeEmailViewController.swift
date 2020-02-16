//
//  ChangeEmailViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD

class ChangeEmailViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTextFields()
    }
    
    func setTextFields() {
        passwordTextField.becomeFirstResponder()
        newEmailTextField.becomeFirstResponder()
        
        passwordTextField.borderStyle = .none
        newEmailTextField.borderStyle = .none
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let newEmailString = newEmailTextField.text!
        let oldEmailString = (Auth.auth().currentUser?.email)!
        let passwordString = passwordTextField.text!
        
        ProgressHUD.show()
        UsersManager.reauthenticateUser(email: oldEmailString, password: passwordString, onSuccess: {
            Auth.auth().currentUser?.updateEmail(to: newEmailString) { (error) in
                if error != nil{
                    ProgressHUD.showError("\(error?.localizedDescription)")
                    return
                }
                Database.database().reference().child(FirebaseNodes.users).child((Auth.auth().currentUser?.uid)!).updateChildValues(["email": newEmailString])
                ProgressHUD.showSuccess("Email successfully changed...")
            }
        }) { (error) in
            ProgressHUD.showError(error)
        }
        
        
        
    }
    
}
