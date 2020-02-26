//
//  AccountViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import Stripe

class AccountViewController: UIViewController {
    
    var customerContext: STPCustomerContext?
    var paymentContext: STPPaymentContext?
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        self.configurePaymentSettings()
    }
    
    func configurePaymentSettings() {
        // Do any additional setup after loading the view.
        let config = STPPaymentConfiguration.shared()
        config.additionalPaymentOptions = .applePay
        config.shippingType = .shipping
        config.requiredBillingAddressFields = STPBillingAddressFields.name
        config.requiredShippingAddressFields = Set<STPContactField>(arrayLiteral: STPContactField.name, STPContactField.emailAddress, STPContactField.phoneNumber, STPContactField.postalAddress)
        config.companyName = "Testing XYZ"
        customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        paymentContext = STPPaymentContext(customerContext: customerContext!, configuration: config, theme: .default())
        self.paymentContext?.delegate = self
        self.paymentContext?.hostViewController = self
        self.paymentContext?.paymentAmount = 5000
    }
    
    @IBAction func paymentSettingsPressed(_ sender: Any) {
        self.paymentContext?.pushPaymentOptionsViewController()
    }
    
    @IBAction func yourOrdersPressed(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
}

extension AccountViewController : STPPaymentContextDelegate {
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
    
    
}
