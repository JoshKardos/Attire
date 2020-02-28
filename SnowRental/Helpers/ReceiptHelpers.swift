//
//  ReceiptHelpers.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/26/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import Stripe

class ReceiptHelpers {
    
    // /////////////////// //
    // RECEIPT VALUE KEYS  //
    // /////////////////// //
    static let itemsPrice = "itemsPrice"
    static let shippingHandlingPrice = "shippingHandlingPrice"
    static let beforeTaxPrice = "beforeTaxPrice"
    static let taxPrice = "taxPrice"
    static let totalPrice = "totalPrice"
    
    static let cardDetails = "cardDetails"
    static let shippingDetails = "shippingDetails"
    static let shippingAddressStreet = "shippingAddressStreet"
    static let shippingAddressDetails = "shippingAddressDetails"
    static let billingAddressStreet = "billingAddressStreet"
    static let billingAddressDetails = "billingAddressDetails"
    
    static func createReceiptValuesMap(order: Order, paymentContext: STPPaymentContext) -> [String: String] {
        var receiptValuesMap: [String: String] = [:]
        let itemsPrice = Double(order.price!)
        let shippingHandlingPrice = Double((paymentContext.selectedShippingMethod?.amount)!)
        let beforeTaxPrice = itemsPrice + shippingHandlingPrice // items is in cents
        let taxPrice = itemsPrice * CheckoutSubmitPaymentViewController.taxRate
        let totalPrice = beforeTaxPrice + taxPrice
        
        receiptValuesMap[ReceiptHelpers.itemsPrice] = String(itemsPrice)
        receiptValuesMap[ReceiptHelpers.shippingHandlingPrice] = String(shippingHandlingPrice)
        receiptValuesMap[ReceiptHelpers.beforeTaxPrice] = String(beforeTaxPrice)
        receiptValuesMap[ReceiptHelpers.taxPrice] = String(taxPrice)
        receiptValuesMap[ReceiptHelpers.totalPrice] = String(totalPrice)
        
        receiptValuesMap[ReceiptHelpers.cardDetails] = paymentContext.selectedPaymentOption?.label
        receiptValuesMap[ReceiptHelpers.shippingDetails] = paymentContext.selectedShippingMethod?.detail
        receiptValuesMap[ReceiptHelpers.shippingAddressStreet] = paymentContext.shippingAddress?.line1
        receiptValuesMap[ReceiptHelpers.shippingAddressDetails] = "\(paymentContext.shippingAddress!.city!), \(paymentContext.shippingAddress!.state!) \(paymentContext.shippingAddress!.postalCode!)"
        
        let card = Card(firstPaymentOption: paymentContext.selectedPaymentOption!)
        receiptValuesMap[ReceiptHelpers.billingAddressStreet] = card.addressLine1
        receiptValuesMap[ReceiptHelpers.billingAddressDetails] = "\(card.city!), \(card.state!) \(card.postalCode!)"

        return receiptValuesMap
    }
    
    static func createReceiptPriceValuesMap(order: Order, paymentContext: STPPaymentContext) -> [String: Double] {
        var receiptValuesMap: [String: Double] = [:]
        let itemsPrice = order.price!
        let shippingHandlingPrice = Double((paymentContext.selectedShippingMethod?.amount)!)
        let beforeTaxPrice = Double(itemsPrice) + shippingHandlingPrice // items is in cents
        let taxPrice = Double(itemsPrice) * CheckoutSubmitPaymentViewController.taxRate
        let totalPrice = beforeTaxPrice + taxPrice
        receiptValuesMap[ReceiptHelpers.itemsPrice] = Double(itemsPrice)
        receiptValuesMap[ReceiptHelpers.shippingHandlingPrice] = shippingHandlingPrice
        receiptValuesMap[ReceiptHelpers.beforeTaxPrice] = beforeTaxPrice
        receiptValuesMap[ReceiptHelpers.taxPrice] = taxPrice
        receiptValuesMap[ReceiptHelpers.totalPrice] = totalPrice
        return receiptValuesMap
    }
    
//    static func createReceiptValuesMap(order: Order, paymentContext: STPPaymentContext) -> [String: String] {
//        let receiptValuesMap: [String: Any] = createReceiptValuesMap(order: order, paymentContext: paymentContext)
//        var receiptValuesStringMap: [String: String] = [:]
//        for (key, value) in receiptValuesMap {
//            print("KEY: \(key) VALUE: \(value)")
//            if let stringValue = value as? String {
//                receiptValuesStringMap[key] = stringValue
//            } else if let doubleValue = (Double(value)) as? String {
//
//            }
//        }
//        return receiptValuesStringMap
//    }
}
