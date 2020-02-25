//
//  BillingOptionsViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/23/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import Stripe
import SwiftyJSON
import ProgressHUD

class BillingOptionsViewController: UIViewController {
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var cardholderNameLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var recentCardContainer: UIView!
    @IBOutlet weak var editCardButton: UIButton!
    
    var paymentContext: STPPaymentContext?
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.paymentContext?.delegate = self
        setUpRecentPaymentMethod()
    }
    
    func setUpRecentPaymentMethod() {
        if paymentContext?.selectedPaymentOption == nil {
            recentCardContainer.alpha = 0
            editCardButton.setTitle("Add card", for: .normal)
            return
        } else {
            recentCardContainer.alpha = 1
            editCardButton.setTitle("Edit card", for: .normal)
        }
        if let firstPaymentOption = paymentContext?.selectedPaymentOption {
            let card = Card(firstPaymentOption: firstPaymentOption)
            self.cardLabel.text = card.label
            self.expiryDateLabel.text = "Expires \(card.expMonth!)/\(card.expYear!)"
            self.cardholderNameLabel.text = card.cardholderName
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToReceipt" {
            let vc = segue.destination as! ReceiptViewController
            vc.order = self.order
            vc.paymentContext = self.paymentContext
        }
    }
    
    @IBAction func editCardPressed(_ sender: Any) {
        self.paymentContext?.presentPaymentOptionsViewController()
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        // check card and shipping
        if paymentContext?.selectedPaymentOption == nil {
            ProgressHUD.showError("Please choose a payment option")
            return
        }
        if paymentContext?.selectedPaymentOption != nil && paymentContext?.shippingAddress != nil && order != nil {
            self.performSegue(withIdentifier: "ToReceipt", sender: nil)
        }
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
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
    
    
}


