//
//  OrdersTableTableViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/25/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit

class OrdersTableViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension OrdersTableViewController: UITableViewDelegate, UITableViewDataSource {
    
}
