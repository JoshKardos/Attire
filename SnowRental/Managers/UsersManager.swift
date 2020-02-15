//
//  UsersManager.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD

class UsersManager {
    static var currentUser = User()
    
    static func loadCurrentUser(uid: String){
        Database.database().reference().child(FirebaseNodes.users).child(uid).observe(.value) { (snapshot) in
            currentUser = User(dictionary: snapshot.value as! NSDictionary)
        }
    }
    static func signUp(email: String, password: String, firstName: String, lastName: String, onSuccess: @escaping() -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Eror creating user: \(error!.localizedDescription)")
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            if let uid = Auth.auth().currentUser?.uid{
                self.signUpUser(firstName: firstName, lastName: lastName, email: email, uid: uid, onSuccess: onSuccess)
            }
        }
    }
    static func signUpUser(firstName: String, lastName: String, email: String, uid: String, onSuccess: @escaping () -> Void){
        
        let usersRef = Database.database().reference().child(FirebaseNodes.users)
        let values = ["firstName": firstName, "lastName": lastName, "email": email, "uid": uid] as [String : Any]
        
        usersRef.child(uid).setValue(values)
        onSuccess()
        
    }
}

