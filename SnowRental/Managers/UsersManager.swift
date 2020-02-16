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
    
    static func logOut(onSuccess: @escaping() -> Void) {
        do {
            try Auth.auth().signOut()
            currentUser = User()
            ProgressHUD.showSuccess("Logged out")
            onSuccess()
        } catch {
            print("ErrorLoggingOut")
            ProgressHUD.showError("Error logging out")
        }
    }
    
    static func loadCurrentUser(uid: String, onSuccess: @escaping() -> Void){
        Database.database().reference().child(FirebaseNodes.users).child(uid).observe(.value) { (snapshot) in
            currentUser = User(dictionary: snapshot.value as! NSDictionary)
            onSuccess()
        }
    }
    
    static func logIn(email: String, password: String, onSuccess: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            loadCurrentUser(uid: (result?.user.uid)!) {
                onSuccess()
            }
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
                Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                
                self.signUpUser(firstName: firstName, lastName: lastName, email: email, uid: uid, onSuccess: onSuccess)
            }
        }
    }
    static func signUpUser(firstName: String, lastName: String, email: String, uid: String, onSuccess: @escaping () -> Void){
        
        let usersRef = Database.database().reference().child(FirebaseNodes.users)
        let values = ["firstName": firstName, "lastName": lastName, "email": email, "uid": uid] as [String : Any]
        
        usersRef.child(uid).setValue(values)
        currentUser = User(dictionary: values as NSDictionary)
        onSuccess()
        
    }
    static func reauthenticateUser(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
        
        let user = Auth.auth().currentUser;
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        //https://stackoverflow.com/questions/38253185/re-authenticating-user-credentials-swift
    
        user?.reauthenticate(with: credential, completion: { (result, error) in
            
            if error != nil {
                onError((error?.localizedDescription)!)
                return
            }
            
            onSuccess()
            return
            
        })
    }
}

