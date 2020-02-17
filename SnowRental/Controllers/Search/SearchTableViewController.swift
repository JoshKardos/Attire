//
//  SearchTableViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/14/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit

class SearchTableViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var resultsTableViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        
        // SET PLACEHOLDER FOR SEARCH BAR
        var myMutableStringTitle = NSMutableAttributedString()
        let searchBarPlaceholder  = "Movie name or design name" // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string : searchBarPlaceholder, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: searchBar.font!.pointSize)]) // font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location : 0, length : searchBarPlaceholder.count))    // color
        searchBar.attributedPlaceholder = myMutableStringTitle
        ///
        searchBar.backgroundColor = resultsTableView.backgroundColor
        searchBar.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMovieViewController" {
            let vc = segue.destination as! MovieViewController
            vc.movie = sender as! [String: String]
        }
    }
    
    @IBAction func searchBarChanged(_ sender: Any) {
        if searchBar.text!.count > 1 {
            MoviesManager.searchMovieFromOMDB(title: searchBar.text!) {
                self.resultsTableView.reloadData()
            }
        }
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {

    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension SearchTableViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MoviesManager.omdbSearchMovies.count < 10 {
            return MoviesManager.omdbSearchMovies.count
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableView", for: indexPath) as! SearchCell
        let movie = MoviesManager.omdbSearchMovies[indexPath.row] as! [String: String]
        cell.configureCell(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = MoviesManager.omdbSearchMovies[indexPath.row] as! [String: String]
        self.performSegue(withIdentifier: "toMovieViewController", sender: movie)
    }
}
