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
import Stripe

class OrdersManager {
    static var currentUsersOrders: [Order]?
    static var currentUsersOrderIds: [String]?
    
    static func clearOrderInfo() {
        currentUsersOrderIds = []
        currentUsersOrders = []
    }
    
    static func saveOrderToDatabase(order: Order?, paymentContext: STPPaymentContext, onSuccess: @escaping() -> Void) {
        if let orderId = order?.id, let uid = order?.userId, let designId = order?.design?.designId,
            let movieId = order?.design?.movieId, let size = order?.size, let price = order?.price,
            let shirtHex = order?.shirtHex, let designUrl = order?.imageURL?.absoluteString,
            let newOrder = order { // "user-orders/{user}/{orderId}/1"
            Database.database().reference().child(FirebaseNodes.designOrders).child(designId).child(orderId).setValue(1) // design-orders/{designId}/{orderId}/1
            Database.database().reference().child(FirebaseNodes.userOrders).child(uid).child(orderId).setValue(1) // user-order/{uid}/{orderId}/1
            let receiptValues: [String: String] = ReceiptHelpers.createReceiptValuesMap(order: newOrder, paymentContext: paymentContext)
            print(receiptValues)
            let value: [String : String] = [
                FirebaseNodes.price: String(price),
                FirebaseNodes.orderId: orderId,
                FirebaseNodes.timestamp: Date().timeIntervalSince1970.description,
                FirebaseNodes.userId: uid,
                FirebaseNodes.designId: designId,
                FirebaseNodes.movieId: movieId,
                FirebaseNodes.shirtSize: size,
                FirebaseNodes.shirtColor: shirtHex,
                FirebaseNodes.designImageUrl: designUrl,
                FirebaseNodes.itemsPrice: receiptValues[ReceiptHelpers.itemsPrice]!,
                FirebaseNodes.shippingHandlingPrice: receiptValues[ReceiptHelpers.shippingHandlingPrice]!,
                FirebaseNodes.beforeTaxPrice: receiptValues[ReceiptHelpers.beforeTaxPrice]!,
                FirebaseNodes.taxPrice: receiptValues[ReceiptHelpers.taxPrice]!,
                FirebaseNodes.totalPrice: receiptValues[ReceiptHelpers.totalPrice]!,
                FirebaseNodes.cardDetails: receiptValues[ReceiptHelpers.cardDetails]!,
                FirebaseNodes.shippingDetails: receiptValues[ReceiptHelpers.shippingDetails]!,
                FirebaseNodes.shippingAddressStreet: receiptValues[ReceiptHelpers.shippingAddressStreet]!,
                FirebaseNodes.shippingAddressDetails: receiptValues[ReceiptHelpers.shippingAddressDetails]!,
                FirebaseNodes.billingAddressStreet: receiptValues[ReceiptHelpers.billingAddressStreet]!,
                FirebaseNodes.billingAddressDetails: receiptValues[ReceiptHelpers.billingAddressDetails]!
            ]
            Database.database().reference().child(FirebaseNodes.orders).child(orderId).updateChildValues(value) { (error, ref) in
                onSuccess()
            }
        }
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
                Database.database().reference().child(FirebaseNodes.orders).child(orderId).observe(.value) { (snapshot) in
                    if snapshot.exists() {
                        let value = snapshot.value as! [String: Any]
                        let order = Order(dict: value)
                        Database.database().reference().child(FirebaseNodes.designs).child(order.designId!).observe(.value) { (snapshot) in
                            if snapshot.exists() {
                                let value = snapshot.value as! [String: String]
                                let design = Design(dictionary: value)
                                order.design = design
                                currentUsersOrders?.append(order)
                                currentUsersOrders?.sort(by: { $0.timestamp! > $1.timestamp! })
                                onSuccess()
                            }
                        }
                    } else {
                        print("corrupt order")
                    }
                }
            }
        }
    }
}
