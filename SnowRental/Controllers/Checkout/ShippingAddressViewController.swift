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
    
    @IBOutlet weak var shippingNameLabel: UILabel!
    @IBOutlet weak var shippingDetailLabel: UILabel!
    var order: Order?
    let indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.frame = recentlyContainer.frame
        indicator.style = .large
        indicator.startAnimating()
        self.view.addSubview(indicator)
        recentlyContainer.alpha = 0
        recentlyContainer.layer.borderWidth = 1
        recentlyContainer.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        recentlyContainer.layer.cornerRadius = 3
        self.paymentContext?.hostViewController = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.paymentContext?.delegate = self
        self.setAddressData(paymentContext: paymentContext!)
    }
    
    @IBAction func editAdressPressed(_ sender: Any) {
        self.paymentContext?.presentShippingViewController()
    }
    @IBAction func continuePressed(_ sender: Any) {
        if paymentContext?.selectedShippingMethod == nil || paymentContext?.shippingAddress == nil {
            self.paymentContext?.presentShippingViewController()
            return
        }
        self.performSegue(withIdentifier: "ToSelectPaymentMethod", sender: nil)
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
        
        if paymentContext.selectedShippingMethod != nil {
            self.shippingNameLabel.text = paymentContext.selectedShippingMethod?.label
            self.shippingDetailLabel.text = paymentContext.selectedShippingMethod?.detail
        } else {
            self.shippingNameLabel.text = "NONE"
            self.shippingDetailLabel.text = "NONE"
        }
    }
}

extension ShippingAddressViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if paymentContext.shippingAddress != nil {
            self.indicator.stopAnimating()
            self.indicator.removeFromSuperview()
            recentlyContainer.alpha = 1
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

