//
//  EditProfileViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/27/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import ProgressHUD
import FirebaseAuth

class EditProfileViewController: UIViewController {

    @IBOutlet weak var firstNameTextFIeld: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    var chosenImage: UIImage?
    var pickerController: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextFIeld.text = UsersManager.currentUser.firstName
        lastNameTextField.text = UsersManager.currentUser.lastName
        firstNameTextFIeld.borderStyle = .none
        lastNameTextField.borderStyle = .none
        
    }
    

    @IBAction func changePhotoPressed(_ sender: Any) {
        pickerController = UIImagePickerController()
        pickerController.mediaTypes = ["public.image"]
        //access to extension
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        // validate text fields
        guard let firstNameString = firstNameTextFIeld.text, let lastNameString = lastNameTextField.text else {
            ProgressHUD.showError("Name field should exist")
            return
        }
        
        if firstNameString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || lastNameString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            ProgressHUD.showError("Name field should not be empty")
            return
        }
        let values: [String: String] = [FirebaseNodes.firstName: firstNameString, FirebaseNodes.lastName: lastNameString]
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        ProgressHUD.show()
        UsersManager.setUserValues(userId: Auth.auth().currentUser!.uid, image: chosenImage, values: values, onSuccess: {
            self.successSaving()
        }, onError:  {
            self.errorSaving()
        })
    }
    
    func successSaving() {
        UIApplication.shared.endIgnoringInteractionEvents()
        ProgressHUD.showSuccess()
        self.navigationController?.popViewController(animated: false)

    }
    
    func errorSaving() {
        UIApplication.shared.endIgnoringInteractionEvents()
        ProgressHUD.showError("Error saving your profile")
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if  let image = info[.originalImage] as? UIImage {
            chosenImage = image
            print("chose image")
        } else{
            ProgressHUD.showError("Error selecting photo... Please try again.")
        }
        dismiss(animated: true, completion: nil)
    }
}
