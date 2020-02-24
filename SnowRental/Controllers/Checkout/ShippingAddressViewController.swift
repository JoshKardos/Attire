//
//  ShippingAddressViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/23/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import Stripe

class ShippingAddressViewController: UIViewController {

    @IBOutlet weak var recentlyContainer: UIView!
    var paymentContext: STPPaymentContext?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentlyContainer.isOpaque = true
        recentlyContainer.isHidden = true
        recentlyContainer.layer.borderWidth = 1
        recentlyContainer.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        recentlyContainer.layer.cornerRadius = 3
        self.paymentContext?.delegate = self
        self.paymentContext?.hostViewController = self
    }
    
    @IBAction func nextPressed(_ sender: Any) {
       self.performSegue(withIdentifier: "ToSelectPaymentMethod", sender: nil)
    }
    
    
    @IBAction func editAdressPressed(_ sender: Any) {
        self.paymentContext?.presentShippingViewController()
    }
    @IBAction func addAdressPressed(_ sender: Any) {
        self.paymentContext?.presentShippingViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSelectPaymentMethod" {
            let vc = segue.destination as! BillingOptionsViewController
            vc.paymentContext = self.paymentContext
            vc.order = self.order
        }
    }
    
    func setAddressData(paymentContext: STPPaymentContext) {
        guard let city = paymentContext.shippingAddress?.city, let state = paymentContext.shippingAddress?.state, let postalCode = paymentContext.shippingAddress?.postalCode else {
            return
        }
        self.nameLabel.text = paymentContext.shippingAddress?.name
        self.adressLabel.text = paymentContext.shippingAddress?.line1
        self.cityLabel.text = "\(city), \(state) \(postalCode)"
        self.countryLabel.text = paymentContext.shippingAddress?.country
        self.phoneLabel.text = paymentContext.shippingAddress?.phone
    }
}

extension ShippingAddressViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if paymentContext.shippingAddress != nil {
            recentlyContainer.isOpaque = false
            recentlyContainer.isHidden = false
            self.setAddressData(paymentContext: paymentContext)
        }
    }
        
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        
        let fedEx = PKShippingMethod()
        fedEx.amount = 5.99
        fedEx.label = "FedEx"
        fedEx.detail = "Arrives tomorrow"
        fedEx.identifier = "fedex"
        
        if address.country == "US" {
            completion(.valid, nil, [upsGround, fedEx], upsGround)
        } else {
            completion(.invalid, nil, nil, nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("ERROR \(error)")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        print("payment result this should not print")
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {

    }
    
    
}

