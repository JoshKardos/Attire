//
//  PreviewPhotoViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/16/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import AAObnoxiousFilter

class PreviewPhotoViewController: UIViewController {
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    var designMovie: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        imageView.image = image
        print("here")
        if let prediction = image!.predictImage() {
            // prediction if greater than 0.5, the image will have inappropriate look
            print(prediction)
        }
        else {
            // Exception in any other case if the Image is not valid to predict
            print("nothing")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = designMovie, TagsViewController.viewed == false {
            performSegue(withIdentifier: "ShowTagsView", sender: nil)
            return
        } else {
            TagsViewController.viewed = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTagsView" {
            let vc = segue.destination as! TagsViewController
            vc.image = imageView.image
            vc.movie = designMovie
        }
    }

    @IBAction func nextPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "SearchTableViewController") as! SearchTableViewController
        controller.isMovieSearchForDesign = true
        controller.designDelegate = self
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    @IBAction func retakePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PreviewPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FiltersManager.Filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DesignFilterCell", for: indexPath) as! DesignFilterViewCell
        cell.configureCell(image: image!, filter: FiltersManager.Filters[indexPath.row], index: indexPath.row)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DesignFilterViewCell
        imageView.image = cell.imageView.image
    }

}
