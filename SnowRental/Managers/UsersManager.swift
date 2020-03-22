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
import FirebaseStorage
import ProgressHUD

class UsersManager {
    
    static var currentUser = User()
    static var hidePostEnabled = false
    static var blockUserEnabled  = false
    
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
    
    static func loadCurrentUser(onSuccess: @escaping() -> Void){
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child(FirebaseNodes.users).child(id).observe(.value) { (snapshot) in
            if !snapshot.exists() {
                return
            }
            currentUser = User(dictionary: snapshot.value as! NSDictionary)
            // load the users blocked users
            Database.database().reference().child(FirebaseNodes.userBlockedUsers).child(id).observe(.value) { (snapshot) in
                if snapshot.exists() {
                    if let usersMap = snapshot.value as? [String: Any] {
                        let usersIds = usersMap.keys
                        currentUser.setBlockedUsersArr(userIds: Array(usersIds))
                    }
                }
                Database.database().reference().child(FirebaseNodes.userHiddenPosts).child(id).observe(.value) { (snapshot) in
                    if snapshot.exists() {
                        if let designsMap = snapshot.value as? [String: Any] {
                            let designIds = designsMap.keys
                            currentUser.setHiddenDesignIds(designIds: Array(designIds))
                        }
                    }
                    onSuccess()
                }
            }
        }
    }
    
    static func logIn(email: String, password: String, onSuccess: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            loadCurrentUser() {
                let defaults = UserDefaults.standard
                if defaults.string(forKey: UserDefaultKeys.hasLoggedIn) == nil {
                    defaults.set(true, forKey: UserDefaultKeys.hasLoggedIn)
                }
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
        let values = [FirebaseNodes.firstName: firstName, FirebaseNodes.lastName: lastName, FirebaseNodes.email: email, FirebaseNodes.uid: uid, FirebaseNodes.dateJoinedTimestamp: Date().timeIntervalSince1970.description] as [String : Any]
        
        usersRef.child(uid).setValue(values)
        let defaults = UserDefaults.standard
        if defaults.string(forKey: UserDefaultKeys.hasSignedUp) == nil {
            defaults.set(true, forKey: UserDefaultKeys.hasSignedUp)
        }
        currentUser = User(dictionary: values as NSDictionary)
        MyAPIClient.signUpStripeCustomer(userId: uid, email: email, name: "\(firstName) \(lastName)", onSuccess: {
            onSuccess()
        })
    }
    
    static func setUserValuesHelper(userId: String, image: UIImage?, values: [String: String], onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {

        Database.database().reference().child(FirebaseNodes.users).child(userId).updateChildValues(values) { (error, ref) in
            if error != nil {
                onError()
                return
            }
            onSuccess()
        }
    }
    
    static func setUserValues(userId: String, image: UIImage?, values: [String: String], onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        if image != nil {
            let imgData = image?.pngData()
            let storageRef = Storage.storage().reference().child("userImages").child(userId)
            if let imageData = imgData {
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        onError()
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        if error != nil{
                            print("Error downloading URL: \(error?.localizedDescription)")
                            onError()
                            return
                        }
                        
                        //get url of image
                        guard let profileImageUrl = url?.absoluteString else {return}
                        var valuesWithImage = values
                        valuesWithImage[FirebaseNodes.profileImageUrl] = profileImageUrl
                        setUserValuesHelper(userId: userId, image: image, values: valuesWithImage, onSuccess: onSuccess, onError: onError)
                    }
                })
            }
        } else {
            setUserValuesHelper(userId: userId, image: image, values: values, onSuccess: onSuccess, onError: onError)
        }
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
    
    static func blockUser(with id: String, currentUserId: String, onSuccess: @escaping () -> Void) {
        if id == Auth.auth().currentUser?.uid {
            ProgressHUD.showError("Cannot block yourself")
            return
        }
        ProgressHUD.show()
        Database.database().reference().child(FirebaseNodes.userBlockedUsers).child(currentUserId).child(id).setValue(1) { (error, ref) in
            if error != nil {
                ProgressHUD.showError("Failure blocking")
                return
            }
            onSuccess()
            ProgressHUD.showSuccess()
        }
    }
    
    static func hidePost(with design: Design, currentUserId: String, onSuccess: @escaping () -> Void) {
        if design.userId == Auth.auth().currentUser?.uid {
            ProgressHUD.showError("Cannot hide your own post")
            return
        }
        ProgressHUD.show()
        Database.database().reference().child(FirebaseNodes.userHiddenPosts).child(currentUserId).child(design.designId!).setValue(1) { (error, ref) in
            if error != nil {
                ProgressHUD.showError("Failure hiding")
                return
            }
            onSuccess()
            ProgressHUD.showSuccess()
        }
    }
    
}

