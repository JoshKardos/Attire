//
//  ReceiptViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/24/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import Stripe
import ProgressHUD
import FirebaseDatabase
import FirebaseAuth

class CheckoutSubmitPaymentViewController: UIViewController {

    var order: Order?
    var paymentContext: STPPaymentContext?
    var taxRate: Double = 0.1
    
    // receipt container
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var shippingHandlingPriceLabel: UILabel!
    @IBOutlet weak var itemsPriceLabel: UILabel!
    @IBOutlet weak var beforeTaxPriceLabel: UILabel!
    @IBOutlet weak var taxPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var redTotalPriceLabel: UILabel!
    
    // shipping address container
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shippingAddressLabel: UILabel!
    
    //paymnet information container
    @IBOutlet weak var cardDetailsLabel: UILabel!
    
    // shipping details container
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paymentContext?.delegate = self
        self.configureReceipt()
        self.configureOrderInformation()
    }
    
    func configureOrderInformation() {
        self.nameLabel.text = paymentContext?.shippingAddress?.name
        self.shippingAddressLabel.text = paymentContext?.shippingAddress?.line1
        
        self.cardDetailsLabel.text = Card(firstPaymentOption: paymentContext!.selectedPaymentOption!).label
        
        self.deliveryPriceLabel.text = Double(paymentContext!.selectedShippingMethod!.amount) > 0.0 ? "$\(paymentContext!.selectedShippingMethod!.amount)  \(paymentContext!.selectedShippingMethod!.detail!)" : "FREE  \(paymentContext!.selectedShippingMethod!.detail!)"

    }
    
    func configureReceipt() {
        let itemsPrice = Double(order!.price!/100)
        let shippingHandlingPrice = Double((paymentContext?.selectedShippingMethod?.amount)!)
        let beforeTaxPrice = itemsPrice + shippingHandlingPrice // items is in cents
        let taxPrice = itemsPrice * taxRate
        let totalPrice = beforeTaxPrice + taxPrice
        itemsPriceLabel.text = String(format: "$%.02f", itemsPrice)
        shippingHandlingPriceLabel.text = String(format: "$%.02f", shippingHandlingPrice)
        beforeTaxPriceLabel.text = String(format: "$%.02f", beforeTaxPrice)
        taxPriceLabel.text = String(format: "$%.02f", taxPrice)
        totalPriceLabel.text = String(format: "$%.02f", totalPrice)
        redTotalPriceLabel.text = String(format: "$%.02f", totalPrice)
        
        let addressText = "\((paymentContext?.shippingAddress?.name)!), \((paymentContext?.shippingAddress?.line1)!)"
        addressLabel.text = addressText
        
    }
    
    @IBAction func placeOrderPressed(_ sender: Any) {
        self.paymentContext?.requestPayment()
    }
    
}

extension CheckoutSubmitPaymentViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
    }
        
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
    
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("ERROR \(error)")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
        var amount = Double(paymentContext.paymentAmount) + (Double(order!.price!)*taxRate) // add tax
        let customerId = UsersManager.currentUser.stripeCustomerId!
        
        ProgressHUD.show()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        MyAPIClient.createPaymentIntent(amount: amount, currency: "usd", customerId: customerId) { (response) in
            switch response {
            case .success(let clientSecret):
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
                paymentIntentParams.paymentMethodParams = paymentResult.paymentMethodParams

                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { (status, paymentIntent, error) in
                    switch status {
                    case .succeeded:
                        self.order?.id = paymentIntent!.stripeId
                        self.order?.price = Int(amount)
                        completion(.success, nil)
                        break
                    case .failed:
                        completion(.error, error)
                        break
                    case .canceled:
                        completion(.userCancellation, nil)
                        break
                    @unknown default:
                        completion(.error, nil)
                        break
                    }
                }
                break
            case .failure(let error):
                completion(.error, error)
                break
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        switch status {
        case .success:
            if let orderId = order?.id, let uid = order?.userId, let designId = order?.design?.designId, let movieId = order?.design?.movieId, let size = order?.size, let price = order?.price, let shirtHex = order?.shirtColor?.hexCode { // "user-orders/{user}/{orderId}/1"
                Database.database().reference().child(FirebaseNodes.userOrders).child(uid).child(orderId).setValue(1)
            
                let value: [String : Any] = [FirebaseNodes.orderId: orderId, FirebaseNodes.timestamp: Date().timeIntervalSince1970.description, FirebaseNodes.userId: uid, FirebaseNodes.designId: designId, FirebaseNodes.movieId: movieId, FirebaseNodes.shirtSize: size, FirebaseNodes.price: price, FirebaseNodes.shirtColor: shirtHex]
                Database.database().reference().child(FirebaseNodes.orders).child(orderId).updateChildValues(value)
                print("success")
                Database.database().reference().child(FirebaseNodes.designOrders).child(designId).child(orderId).setValue(1) // design-orders/{designId}/{orderId}/1
            }
            // "orders/{orderId}/
                       // orderId
                       // timestamp
                       // userId
                       // designId
                       // movieId
                       // shirtSize
                       // price
                       // shirtColor
            ProgressHUD.showSuccess("Your order has been successfuly placed")
            UIApplication.shared.endIgnoringInteractionEvents()
            self.navigationController?.popToRootViewController(animated: false)
            break
        case .error:
            ProgressHUD.showError("Failed to submit order")
            UIApplication.shared.endIgnoringInteractionEvents()
            break
        case .userCancellation:
            ProgressHUD.showError("Failed to submit order")
            UIApplication.shared.endIgnoringInteractionEvents()
            break
         @unknown default:
            ProgressHUD.showError("Failed to submit order")
            UIApplication.shared.endIgnoringInteractionEvents()
            break
        }
    }
}
