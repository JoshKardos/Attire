//
//  SearchViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/13/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SearchViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var freeReturnsLabel: UILabel!
    @IBOutlet weak var qualityOrganicLabel: UILabel!
    @IBOutlet weak var timelessAttireLabel: UILabel!
    @IBOutlet weak var youMightLikeCollectionView: UICollectionView!
    @IBOutlet weak var addDesignButton: UIButton!
    
    let searchBarMaxTopConstraint: CGFloat = 260
    let searchBarMinTopConstraint: CGFloat = -20
    let headerSearchBarDistance: CGFloat = 20.5 //50.66666793823242
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        MoviesManager.fetchMovies {
            self.youMightLikeCollectionView.reloadData()
        }
        
        scrollView.delegate = self
        youMightLikeCollectionView.dataSource = self
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.backgroundColor = UIColor.clear
        headerLabel.font = UIFont.boldSystemFont(ofSize: 29.0)
        configureScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.resignFirstResponder() // remove focus
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addDesignPressed(_ sender: Any) {
        
        if Auth.auth().currentUser == nil {
            self.performSegue(withIdentifier: "ShowAuthenticationStoryboard", sender: nil)
        } else {
            self.tabBarController!.selectedIndex = 1
            print("logged in")
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("began editing")
        // segue to search controller
        performSegue(withIdentifier: "ShowSearchTableViewController", sender: self)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("end editing")

    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MoviesManager.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouMightLikeCell", for: indexPath) as! YouMightLikeCell
        let movieNames = Array(MoviesManager.movies.keys)
        let movieName = movieNames[indexPath.row]
        let movie = MoviesManager.movies[movieName] as! Dictionary<String, Any>
        cell.configureCell(shirtDesign: movie)
        return cell
    }
    
    
}

extension SearchViewController: UIScrollViewDelegate {
    func configureScrollView() {
        addDesignButton.layer.borderWidth = 1
        addDesignButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        timelessAttireLabel.font = UIFont.boldSystemFont(ofSize: 32)
        qualityOrganicLabel.font = UIFont.boldSystemFont(ofSize: 32)
        freeReturnsLabel.font = UIFont.boldSystemFont(ofSize: 32)
    }
    func handleHeaderLabel() {
        if !(searchBarContainer.frame.minY > headerLabel.frame.maxY) {
            headerLabel.alpha = 0
            return
        } else {
            let currentDistance = searchBarContainer.frame.minY - headerLabel.frame.maxY
            headerLabel.alpha = (currentDistance)/headerSearchBarDistance
        }
    }
    
    func searchBarNotAtTop() {
        searchBar.layer.borderWidth = 8
        searchBar.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchBarContainer.backgroundColor = .clear
    }
    
    func searchBarAtTop() {
        searchBarContainer.backgroundColor = .black
    }
    
    func handleSearchBar() {
        
        let y: CGFloat = scrollView.contentOffset.y
        let newTopAnchor: CGFloat = searchBarTopConstraint.constant - 0.1*y

        if newTopAnchor > searchBarMaxTopConstraint {
            searchBarNotAtTop()
            searchBarTopConstraint.constant = searchBarMaxTopConstraint
        } else if newTopAnchor < searchBarMinTopConstraint {
            searchBarAtTop()
            searchBarTopConstraint.constant = searchBarMinTopConstraint
        } else {
            searchBarNotAtTop()
            searchBarTopConstraint.constant = newTopAnchor
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.handleHeaderLabel()
        self.handleSearchBar()
    }
}

extension SearchViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if Auth.auth().currentUser == nil { // not logged in so check tabs
            if viewController == tabBarController.viewControllers![1] || viewController == tabBarController.viewControllers![2] { // cannot be in design or orders
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: "InitialViewController")
                self.present(controller, animated: false, completion: nil)
                return false
            }
        }
        return true
    }
}
