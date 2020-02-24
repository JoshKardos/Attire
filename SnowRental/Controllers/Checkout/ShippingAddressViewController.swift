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
    var addressChosen = false
    var isSetShipping = true

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
    
    override func viewDidAppear(_ animated: Bool) {
        print("DID APPEAR")
        addressChosen = false
        isSetShipping = true
    }
    
    @IBAction func deliverPressed(_ sender: Any) {
        addressChosen = true
        self.paymentContext?.presentShippingViewController()
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
        
//        if paymentContext.selectedPaymentOption != nil && isSetShipping {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                paymentContext.presentShippingViewController()
//            }
//        }
        if paymentContext.shippingAddress != nil && !isSetShipping && addressChosen {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "ToSelectPaymentMethod", sender: nil)
            }
        }
    }
        
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        
        if !addressChosen {
            completion(.valid, nil, nil, nil) // dont add shipping method i.e. express shipping
            return
        }
        
        isSetShipping = false
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
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {

    }
    
    
}

