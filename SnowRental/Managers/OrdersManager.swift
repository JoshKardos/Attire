//
//  OrdersManager.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/25/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class OrdersManager {
    static var currentUsersOrders: [Order]?
    static var currentUsersOrderIds: [String]?
    
    static func clearOrderInfo() {
        currentUsersOrderIds = []
        currentUsersOrders = []
    }
    static func fetchAllOrdersFromCurrentUser(onSuccess: @escaping() -> Void, onEmpty: @escaping() -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        clearOrderInfo()
        Database.database().reference().child(FirebaseNodes.userOrders).child(userId).observe(.value) { (snapshot) in
            if !snapshot.exists() {
                print("user has no orders")
                onEmpty()
                return
            }
            let values = snapshot.value as! [String: Any]
            let orderIds = Array(values.keys)
            currentUsersOrderIds = orderIds
            for orderId in orderIds {
                print(orderId)
                Database.database().reference().child(FirebaseNodes.orders).child(orderId).observe(.value) { (snapshot) in
                    if snapshot.exists() {
                        let value = snapshot.value as! [String: Any]
                        let order = Order(dict: value)
                        Database.database().reference().child(FirebaseNodes.designs).child(order.designId!).observe(.value) { (snapshot) in
                            let value = snapshot.value as! [String: String]
                            let design = Design(dictionary: value)
                            order.design = design
                            currentUsersOrders?.append(order)
                            currentUsersOrders?.sort(by: { $0.timestamp! > $1.timestamp! })
                            onSuccess()
                        }
                    } else {
                        print("corrupt order")
                    }
                }
            }
        }
    }
}
