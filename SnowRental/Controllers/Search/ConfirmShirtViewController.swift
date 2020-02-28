//
//  OrderViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/19/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import Stripe
import FirebaseAuth
// this class is going to handle the checkout process
    // choosing card
    // shipping details
    // going through with payment
class ConfirmShirtViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shirtImageView: UIImageView!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var designImageView: UIImageView!

    var design: Design?
    var movie: [String: String]?
    var shirtColor: UIColor? = UIColor.white
    var imageURL: URL?
    var sizes = ["S", "M", "L", "XL"]
    
    var color: [UIColor: UIImage?] = [
        UIColor.white: UIImage(named: "WhiteShirt")
    ]

    var customerContext: STPCustomerContext?
    var paymentContext: STPPaymentContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = String(format: "$%.02f", Double(design!.price)/100)
        designImageView.kf.setImage(with: self.imageURL)
        
    }
    
    func configureData(design: Design, movie: [String: String]) {
        guard let designUrl = design.imageUrl else {
            return
        }
        let url = URL(string: designUrl)
        self.imageURL = url
        self.design = design
        self.movie = movie
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCheckout" {
            let vc = segue.destination as! CheckoutShippingDetailsViewController
            vc.paymentContext = self.paymentContext
            guard let orderDesign = design, let orderMovie = movie, let orderShirtColor = shirtColor, let orderImageURL = imageURL, let uid = Auth.auth().currentUser?.uid else {
                print("order constructor failed")
                return
            }
            vc.order = Order(design: orderDesign, movie: orderMovie, shirtColor: orderShirtColor, imageUrl: orderImageURL, price: design!.price, size: sizes[sizeSegmentedControl.selectedSegmentIndex], userId: uid)
        }
    }
    
    @IBAction func checkoutPressed(_ sender: Any) {
        // check is logged in
        if Auth.auth().currentUser == nil {
            self.performSegue(withIdentifier: "ToAuthentication", sender: nil)
            return
        }
        
        let config = STPPaymentConfiguration()
        config.additionalPaymentOptions = .applePay
        config.shippingType = .shipping
        config.requiredBillingAddressFields = STPBillingAddressFields.full
        config.requiredShippingAddressFields = Set<STPContactField>(arrayLiteral: STPContactField.name, STPContactField.phoneNumber, STPContactField.postalAddress)
        config.companyName = "Testing XYZ"
        customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        paymentContext = STPPaymentContext(customerContext: customerContext!, configuration: config, theme: .default())
        self.paymentContext?.paymentAmount = design!.price // in cents
    
        // perform checkout storyboard
        self.performSegue(withIdentifier: "ToCheckout", sender: nil)
    }
    
}
