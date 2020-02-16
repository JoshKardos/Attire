//
//  ContactInfoViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/15/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit

class ContactInfoViewController: UIViewController {

    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var passwordContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let emailPressedGesture = UITapGestureRecognizer(target: self, action:  #selector(self.emailPressed))
        self.emailContainer.addGestureRecognizer(emailPressedGesture)
    }

    @objc func emailPressed(sender : UITapGestureRecognizer) {
        print("clicked email")
    }
}
