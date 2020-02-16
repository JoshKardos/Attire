//
//  LoginViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import ProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTextFields()
    }
    
    func setTextFields() {
        emailTextField.becomeFirstResponder()
        passwordTextField.becomeFirstResponder()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        emailTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
        
        SignUpViewController.setPlaceholder(textField: emailTextField, placeholderString: "Email")
        SignUpViewController.setPlaceholder(textField: passwordTextField, placeholderString: "Password")
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
            
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        ProgressHUD.show()
        if self.validTextFields() {
            UsersManager.logIn(email: emailTextField.text!, password: passwordTextField.text!) {
                self.navigationController?.dismiss(animated: false, completion: {
                    
                    ProgressHUD.showSuccess("Logged in")
                })
            }
        } else {
            ProgressHUD.showError("Empty field...")
        }
    }
    
    func validTextFields() -> Bool{
        if passwordTextField.text!.isEmpty || passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || emailTextField.text!.isEmpty || emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        } else {
            return true
        }
    }
    
}
