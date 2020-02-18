//
//  PreviewPhotoViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/16/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = designMovie {
            performSegue(withIdentifier: "ShowTagsView", sender: nil)
            return
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
        FiltersManager.removeData()
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
        print("clicked")
        imageView.image = FiltersManager.filteredImages[FiltersManager.Filters[indexPath.row].filterName]
    }

}
