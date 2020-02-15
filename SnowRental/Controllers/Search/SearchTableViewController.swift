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
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var resultsTableViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        resultsTableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // SET PLACEHOLDER FOR SEARCH BAR
        var myMutableStringTitle = NSMutableAttributedString()
        let searchBarPlaceholder  = "Movie name or design name" // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string : searchBarPlaceholder, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20.0)]) // font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location : 0, length : searchBarPlaceholder.count))    // color
        searchBar.attributedPlaceholder = myMutableStringTitle
        ///
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        resultsTableViewBottomConstraint.constant = 260
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension SearchTableViewController: UITextFieldDelegate {
    
}
