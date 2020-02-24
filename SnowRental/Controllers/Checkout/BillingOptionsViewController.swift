//
//  BillingOptionsViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/23/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import Stripe

class BillingOptionsViewController: UIViewController {
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var cardholderNameLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    
    var paymentContext: STPPaymentContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paymentContext?.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func editCardPressed(_ sender: Any) {
        self.paymentContext?.presentPaymentOptionsViewController()
    }
    @IBAction func submitOrderPressed(_ sender: Any) {
        // check card and shipping
        self.paymentContext?.requestPayment()
    }
}

extension BillingOptionsViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
    }
        
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
    
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("ERROR \(error)")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        MyAPIClient.createPaymentIntent(amount: (Double(paymentContext.paymentAmount+Int((paymentContext.selectedShippingMethod?.amount)!))), currency: "usd", customerId: UsersManager.currentUser.stripeCustomerId!) { (response) in
            print("REPONSE \(response)")
            switch response {
            case .success(let clientSecret):
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
                paymentIntentParams.paymentMethodParams = paymentResult.paymentMethodParams

                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { (status, paymentIntent, error) in
                    switch status {
                    case .succeeded:
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
        
        // add order to firebase "user-orders/{user}/{orderId}/1"
        print("DID FINISH \(status)")
        // "orders/{orderId}/
            // orderId
            // timestamp
            // userId
            // designId
            // movieId
            // shirtSize
            // price
            // shirtColor
        self.navigationController?.popToRootViewController(animated: false)
        
    }
    
    
}


