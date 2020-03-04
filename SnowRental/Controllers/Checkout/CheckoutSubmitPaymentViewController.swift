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
import FirebaseAuth

class CheckoutSubmitPaymentViewController: UIViewController {

    var order: Order?
    var paymentContext: STPPaymentContext?
    static var taxRate: Double = 0.1
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil || UsersManager.currentUser.uid == nil {
            self.navigationController?.popToRootViewController(animated: false)
            return
        }
    }
    
    func configureOrderInformation() {
        self.nameLabel.text = paymentContext?.shippingAddress?.name
        self.shippingAddressLabel.text = paymentContext?.shippingAddress?.line1
        
        self.cardDetailsLabel.text = Card(firstPaymentOption: paymentContext!.selectedPaymentOption!).label
        
        self.deliveryPriceLabel.text = Double(paymentContext!.selectedShippingMethod!.amount) > 0.0 ? "$\(paymentContext!.selectedShippingMethod!.amount)  \(paymentContext!.selectedShippingMethod!.detail!)" : "FREE  \(paymentContext!.selectedShippingMethod!.detail!)"

    }
    
    func configureReceipt() {
        let receiptValuesMap: [String: Double] = ReceiptHelpers.createReceiptPriceValuesMap(order: order!, paymentContext: paymentContext!)
        itemsPriceLabel.text = String(format: "$%.02f", receiptValuesMap[ReceiptHelpers.itemsPrice]!/100)
        shippingHandlingPriceLabel.text = String(format: "$%.02f", receiptValuesMap[ReceiptHelpers.shippingHandlingPrice]!)
        beforeTaxPriceLabel.text = String(format: "$%.02f", receiptValuesMap[ReceiptHelpers.beforeTaxPrice]!/100)
        taxPriceLabel.text = String(format: "$%.02f", receiptValuesMap[ReceiptHelpers.taxPrice]!/100)
        totalPriceLabel.text = String(format: "$%.02f", receiptValuesMap[ReceiptHelpers.totalPrice]!/100)
        redTotalPriceLabel.text = String(format: "$%.02f", receiptValuesMap[ReceiptHelpers.totalPrice]!/100)
        let addressText = "\((paymentContext?.shippingAddress?.name)!), \((paymentContext?.shippingAddress?.line1)!)"
        addressLabel.text = addressText
        
    }
    
    @IBAction func placeOrderPressed(_ sender: Any) {
        if Auth.auth().currentUser == nil || UsersManager.currentUser.uid == nil {
            self.navigationController?.popToRootViewController(animated: false)
            ProgressHUD.showError("Must be logged in")
            return
        }
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
        
        var amount = Double(paymentContext.paymentAmount) + (Double(order!.price!)*CheckoutSubmitPaymentViewController.taxRate) // add tax
        
        guard let customerId = UsersManager.currentUser.stripeCustomerId else {
            self.navigationController?.popToRootViewController(animated: false)
            ProgressHUD.showError("Must have stripe id")
            return
        }
        
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
            OrdersManager.saveOrderToDatabase(order: self.order, paymentContext: paymentContext) {
                let defaults = UserDefaults.standard
                if defaults.string(forKey: UserDefaultKeys.hasMadeOrder) == nil {
                    defaults.set(true, forKey: UserDefaultKeys.hasMadeOrder)
                }
                ProgressHUD.showSuccess("Your order has been successfuly placed")
                UIApplication.shared.endIgnoringInteractionEvents()
                self.navigationController?.popToRootViewController(animated: false)
            }
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
