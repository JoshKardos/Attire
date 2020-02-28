//
//  OrdersTableTableViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/25/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import ProgressHUD

class OrdersTableViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredOrders: [Order]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPastOrderViewController" {
            let vc = segue.destination as! OrderViewController
            let order = sender as! Order
            vc.order = order
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        OrdersManager.fetchAllOrdersFromCurrentUser(onSuccess: {
            if OrdersManager.currentUsersOrders?.count == OrdersManager.currentUsersOrderIds?.count {
                self.tableView.reloadData()
            }
        }, onEmpty: {
            // do nothing
            self.tableView.reloadData()
        })
    }
    
}

extension OrdersTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBar.text!.isEmpty && self.searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            guard let currentUsersCount = OrdersManager.currentUsersOrders?.count else {
                return 0
            }
            return currentUsersCount
        }
        guard let filteredOrdersCount = self.filteredOrders?.count else {
            return 0
        }
        // search bar
        return filteredOrdersCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        if self.searchBar.text!.isEmpty && self.searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            cell.configureCell(order: OrdersManager.currentUsersOrders![indexPath.row])
        } else {
            // search bar
            cell.configureCell(order: self.filteredOrders![indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var order: Order?
        
        if self.searchBar.text!.isEmpty && self.searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if let usersOrder = OrdersManager.currentUsersOrders?[indexPath.row] {
                order = usersOrder
            }
        } else {
            // search bar
            if let filteredOrder = filteredOrders?[indexPath.row] {
                order = filteredOrder
            }
        }
        guard let _ = order else {
            ProgressHUD.showError("Please reload application")
            return
        }
        
        self.performSegue(withIdentifier: "ToPastOrderViewController", sender: order)
    }
}

extension OrdersTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContent(searchText: searchBar.text!)
    }
    
    func filterContent(searchText: String) {
        self.filteredOrders = OrdersManager.currentUsersOrders!.filter { order in
            guard let orderId = order.orderId, let movieName = order.design?.movieName, let designId = order.designId else {
                return true
            }
            let string = "\(orderId) \(movieName) \(designId)"
            return(string.lowercased().contains(searchText.lowercased()))
            
        }
        
        self.tableView.reloadData()
    }
}
