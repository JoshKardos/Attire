//
//  OrderDetailsViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/26/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    
    // view order details
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderTotalLabel: UILabel!
    // shipping details
    @IBOutlet weak var shippingDetailsLabel: UILabel!
    // payment information
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var billingAddressStreetLabel: UILabel!
    @IBOutlet weak var billingAddressDetailsLabel: UILabel!
    // shipping address
    @IBOutlet weak var shippingAddressStreetLabel: UILabel!
    @IBOutlet weak var shippingAddressDetailsLabel: UILabel!
    // order summary
    @IBOutlet weak var itemsPriceLabel: UILabel!
    @IBOutlet weak var shippingHandlingLabel: UILabel!
    @IBOutlet weak var beforeTaxLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var orderSummaryTotalLabel: UILabel!
    
    @IBOutlet var greyBorder: [UIView]!
    
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()

    }
    
    func configureView() {
        
        orderDateLabel.text = order?.timestamp?.toMonthDayYear()
        orderNumberLabel.text = order?.orderId
        orderTotalLabel.text = order?.totalPrice?.centsToDollarFormatted()
        
        shippingDetailsLabel.text = order?.shippingDetails
        
        paymentMethodLabel.text = order?.cardDetails
        billingAddressStreetLabel.text = order?.billingAddressStreet
        billingAddressDetailsLabel.text = order?.billingAddressDetails
        
        shippingAddressStreetLabel.text = order?.shippingAddressStreet
        shippingAddressDetailsLabel.text = order?.shippingAddressDetails
        
        itemsPriceLabel.text = order?.itemsPrice?.centsToDollarFormatted()
        shippingHandlingLabel.text = order?.shippingHandlingPrice?.centsToDollarFormatted()
        beforeTaxLabel.text = order?.beforeTaxPrice?.centsToDollarFormatted()
        taxLabel.text = order?.taxPrice?.centsToDollarFormatted()
        orderSummaryTotalLabel.text = order?.totalPrice?.centsToDollarFormatted()
        
        for view in self.greyBorder {
            view.layer.borderColor = #colorLiteral(red: 0.8784179318, green: 0.8784179318, blue: 0.8784179318, alpha: 1)
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 3
        }
    
    }

}
