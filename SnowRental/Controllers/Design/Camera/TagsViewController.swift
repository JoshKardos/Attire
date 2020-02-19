//
//  TagsViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/17/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import TaggerKit

class TagsViewController: UIViewController, TKCollectionViewDelegate {

    @IBOutlet weak var tagsContainerView: UIView!
    @IBOutlet weak var addContainerView: UIView!
    @IBOutlet weak var textField: TKTextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addedTagsLabel: UILabel!
    
    static var viewed = false
    
    var productTagsCollection = TKCollectionView()
    var addTagsCollection = TKCollectionView()
    var image: UIImage!
    var movie: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        textField.placeholder = "Add a tag"
        textField.becomeFirstResponder()
        add(addTagsCollection, toView: addContainerView)
        textField.sender = addTagsCollection
        addTagsCollection.action = .addTag
        
        add(productTagsCollection, toView: tagsContainerView)
        productTagsCollection.action = .removeTag
        textField.receiver = productTagsCollection
        productTagsCollection.tags = []

        addTagsCollection.receiver = productTagsCollection
                    
        productTagsCollection.delegate = self
        addTagsCollection.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TagsViewController.viewed = true
        
        //need to change to flase when submitted or cancelled
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDesignSummary" {
            let vc = segue.destination as! ConfirmViewController
            vc.image = image
            vc.movie = movie
            vc.tags = productTagsCollection.tags
        }
    }
    
    func tagIsBeingAdded(name: String?) {
        addedTagsLabel.text = "Added Tags: \(productTagsCollection.tags.count)"
    }
    
    func tagIsBeingRemoved(name: String?) {
        addedTagsLabel.text = "Added Tags: \(productTagsCollection.tags.count)"
    }

    @IBAction func nextPressed(_ sender: Any) {
        performSegue(withIdentifier: "toDesignSummary", sender: nil)
    }
}
