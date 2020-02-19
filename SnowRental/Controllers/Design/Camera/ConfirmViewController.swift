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

class ConfirmViewController: UIViewController {

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
        movieNameLabel.text = movie["Title"]!
        
        if let _ = tags {
            add(tagsCollection, toView: tagsView)
            tagsCollection.tags = tags!
        }
        tagsLabel.text = "Tags (\(tags?.count ?? 0))"
        tagsViewContainer.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tagsViewContainer.layer.borderWidth = 2
        let posterString = movie["Poster"]!
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

        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"

        if let imageData = image?.jpegData(compressionQuality: 0.75) {
            storageRef.putData(imageData, metadata: uploadMetadata) { (metadata, error) in
                if error != nil{
                    print("*** \(error.debugDescription)")
                    ProgressHUD.showError("Failed to upload")
                    return
                }
                storageRef.downloadURL { (photoUrl, error) in
                    if error != nil{
                        print("Error downloading URL: \(error!.localizedDescription)")
                        ProgressHUD.showError("Error downloading URL: \(error!.localizedDescription)")
                        return
                    }
                    guard let url = photoUrl?.absoluteString else{
                        print("No URL")
                        ProgressHUD.showError("No URL")
                        return
                    }

                    ref.child(newDesignKey).updateChildValues(["designId": newDesignKey, "imageUrl": url, "userId": userId, "movieId": String(self.movie!["imdbID"]!)])
                    ProgressHUD.showSuccess("Added desgin!")
                    return
                }
            }
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
