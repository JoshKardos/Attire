//
//  ConfirmViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/17/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import TaggerKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD

class UploadConfirmViewController: UIViewController {

    var image: UIImage?
    var tags: [String]?
    var movie: [String: String]?
    
    @IBOutlet weak var designImageView: UIImageView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var tagsView: UIView!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var tagsViewContainer: UIView!
    
    var tagsCollection = TKCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designImageView.image = image
        guard let movie = movie else {
            return
        }
        movieNameLabel.text = movie[FirebaseNodes.title]!
        
        if let _ = tags {
            add(tagsCollection, toView: tagsView)
            tagsCollection.tags = tags!
        }
        tagsLabel.text = "Tags (\(tags?.count ?? 0))"
        tagsViewContainer.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tagsViewContainer.layer.borderWidth = 2
        let posterString = movie[FirebaseNodes.poster]!
        if posterString == "N/A" {
            return
        }
        let url = URL(string: posterString)
        movieImageView.kf.setImage(with: url)
    }
    
    
    @IBAction func confirmPressed(_ sender: Any) {
        let ref = Database.database().reference().child(FirebaseNodes.designs)
        let newDesignKey = ref.childByAutoId().key!
        let storageRef = Storage.storage().reference(withPath: "designs/\(newDesignKey)")
        guard let userId = Auth.auth().currentUser?.uid else {
            ProgressHUD.showError("Must be logged in")
            return
        }
        
        guard let movieId = self.movie![FirebaseNodes.imdbID] else {
            ProgressHUD.showError("Must have a movie picked")
            return
        }

        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"

        ProgressHUD.show()
        UIApplication.shared.beginIgnoringInteractionEvents()
//        self.view.isUserInteractionEnabled = true
        if let imageData = image?.jpegData(compressionQuality: 0.75) {
            storageRef.putData(imageData, metadata: uploadMetadata) { (metadata, error) in
                if error != nil{
                    print("*** \(error.debugDescription)")
                    ProgressHUD.showError("Failed to upload")
                    UIApplication.shared.endIgnoringInteractionEvents()
                    return
                }
                storageRef.downloadURL { (photoUrl, error) in
                    if error != nil{
                        print("Error downloading URL: \(error!.localizedDescription)")
                        ProgressHUD.showError("Error downloading URL: \(error!.localizedDescription)")
                        UIApplication.shared.endIgnoringInteractionEvents()
                        return
                    }
                    guard let url = photoUrl?.absoluteString else{
                        print("No URL")
                        ProgressHUD.showError("No URL")
                        UIApplication.shared.endIgnoringInteractionEvents()
                        return
                    }

                    ref.child(newDesignKey).updateChildValues([FirebaseNodes.designId: newDesignKey, FirebaseNodes.imageUrl: url, FirebaseNodes.userId: userId, FirebaseNodes.movieId: movieId])
                    Database.database().reference().child(FirebaseNodes.movieDesigns).child(movieId).updateChildValues([newDesignKey: "1"])
                    var designTags: [String: String] = [:]
                    if let newTags = self.tags {
                        for tag in newTags {
                            designTags[tag] = "1"
                        }
                        Database.database().reference().child(FirebaseNodes.designTags).child(newDesignKey).updateChildValues(designTags)
                    }
                    ProgressHUD.showSuccess("Added design!")
                    self.navigationController?.popToRootViewController(animated: false)
                    UIApplication.shared.endIgnoringInteractionEvents()

                    return
                }
            }
        } else {
            ProgressHUD.showError("Failed to upload")
            UIApplication.shared.endIgnoringInteractionEvents()

        }

    }
    
    // when confirm is pressed
    //STORAGE
    // save image in /designs/[designId]
    //DATABSE
    // save design in "design"
        // designId
        // imageUrl
        // userId
        // movieId
    // save designid in "movies-design"
        //designId
}
