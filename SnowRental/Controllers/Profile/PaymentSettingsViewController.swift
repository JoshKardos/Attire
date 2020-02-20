//
//  PaymentSettingsViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/19/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit

class PaymentSettingsViewController: UIViewController {

    @IBOutlet weak var addPaymentButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addPaymentButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        addPaymentButton.layer.borderWidth = 1
        addPaymentButton.layer.cornerRadius = 4
    }
    
    @IBAction func addPaymentMethodPressed(_ sender: Any) {
        
    }

}
