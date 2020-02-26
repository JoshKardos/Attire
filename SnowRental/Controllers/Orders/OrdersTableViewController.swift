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
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        OrdersManager.fetchAllOrdersFromCurrentUser(onSuccess: {
            if OrdersManager.currentUsersOrders!.count == OrdersManager.currentUsersOrderIds!.count {
                self.tableView.reloadData()
            }
        }, onEmpty: {
            // do nothing
        })
    }
    
}

extension OrdersTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let currentUsersCount = OrdersManager.currentUsersOrders?.count else {
            return 0
        }
        return currentUsersCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.configureCell(order: OrdersManager.currentUsersOrders![indexPath.row])
        return cell
    }
}

extension OrdersTableViewController: UISearchBarDelegate {
    
}
