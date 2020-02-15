//
//  SignUpViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import ProgressHUD

class SignUpViewController: UIViewController {
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTextFields()
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if validTextFields(){
        ProgressHUD.show("Waiting...", interaction: false)
            UsersManager.signUp(email: self.emailTextField.text!, password: self.passwordTextField.text!, firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!,  onSuccess: {
                self.navigationController?.dismiss(animated: false, completion: {
                    ProgressHUD.showSuccess("Success creating your profile")
                })
            })
        }  else {
            ProgressHUD.showError("There are empty fields...")
        }
    }
    
    func setPlaceholder(textField: UITextField, placeholderString: String) {
        var placeholderMutableStringTitle = NSMutableAttributedString()
        let placeholder  = placeholderString // PlaceHolderText
        placeholderMutableStringTitle = NSMutableAttributedString(string : placeholder, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: textField.font!.pointSize)]) // font
        placeholderMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range:NSRange(location : 0, length : placeholder.count))    // color
        textField.attributedPlaceholder = placeholderMutableStringTitle
    }
    
    func setTextFields() {
        
        emailTextField.becomeFirstResponder()
        passwordTextField.becomeFirstResponder()
        firstNameTextField.becomeFirstResponder()
        lastNameTextField.becomeFirstResponder()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        
        emailTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
        firstNameTextField.borderStyle = .none
        lastNameTextField.borderStyle = .none
        
        self.setPlaceholder(textField: emailTextField, placeholderString: "Email")
        self.setPlaceholder(textField: passwordTextField, placeholderString: "Password")
        self.setPlaceholder(textField: firstNameTextField, placeholderString: "First name")
        self.setPlaceholder(textField: lastNameTextField, placeholderString: "Last name")
        
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
            
    }
    
    func validTextFields() -> Bool{
        if !emailTextField.text!.isEmpty && !(emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
            && !firstNameTextField.text!.isEmpty && !(firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
            && !lastNameTextField.text!.isEmpty && !(lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
            && !passwordTextField.text!.isEmpty && !(passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return true
        }
        return false
    }
}
