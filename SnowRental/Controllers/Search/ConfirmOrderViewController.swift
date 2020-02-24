//
//  OrderViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/19/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import ChromaColorPicker
import Stripe
import FirebaseAuth
// this class is going to handle the checkout process
    // choosing card
    // shipping details
    // going through with payment
class ConfirmOrderViewController: UIViewController, ChromaColorPickerDelegate {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var designImageView: UIImageView!
    @IBOutlet weak var colorPicker: ChromaColorPicker!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    
    var design: Design?
    var movie: [String: String]?
    var shirtColor: UIColor?
    var imageURL: URL?
    var sizes = ["S", "M", "L", "XL"]
    var price = 4000

    var customerContext: STPCustomerContext?
    var paymentContext: STPPaymentContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = "$\(Double(price)/100.00)"
        designImageView.kf.setImage(with: self.imageURL)
        self.configureColorPicker()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCheckout" {
            let vc = segue.destination as! ShippingAddressViewController
            
            vc.paymentContext = self.paymentContext

            guard let orderDesign = design, let orderMovie = movie, let orderShirtColor = shirtColor, let orderImageURL = imageURL, let uid = Auth.auth().currentUser?.uid else {
                print("here")
                return
            }
            //set up vc - color, size, price, design
            vc.order = Order(design: orderDesign, movie: orderMovie, shirtColor: orderShirtColor, imageUrl: orderImageURL, price: price, size: sizes[sizeSegmentedControl.selectedSegmentIndex], userId: uid)
        }
    }
    
    @IBAction func checkoutPressed(_ sender: Any) {
        // check is logged in
        
        let config = STPPaymentConfiguration()
        config.additionalPaymentOptions = .applePay
        config.shippingType = .shipping
        config.requiredBillingAddressFields = STPBillingAddressFields.name
        config.requiredShippingAddressFields = Set<STPContactField>(arrayLiteral: STPContactField.name, STPContactField.phoneNumber, STPContactField.postalAddress)
        config.companyName = "Testing XYZ"
        customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        paymentContext = STPPaymentContext(customerContext: customerContext!, configuration: config, theme: .default())
        self.paymentContext?.paymentAmount = price // in cents
    
        // perform checkout storyboard
        self.performSegue(withIdentifier: "ToCheckout", sender: nil)
    }
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        self.shirtColor = color
    }
    
    func configureColorPicker() {
        self.shirtColor = colorPicker.currentColor
        colorPicker.backgroundColor = view.backgroundColor
        colorPicker.delegate = self
        colorPicker.padding = 0
        colorPicker.stroke = 3
        colorPicker.hexLabel.textColor = UIColor.clear
    }
    
}
