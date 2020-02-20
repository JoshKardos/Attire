//
//  UITextField.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/19/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation

import Foundation
import UIKit

extension UITextField{

    func validateCreditCardFormat() -> Bool{
        let numberOnly = self.text!.replacingOccurrences(of: " ", with: "")
        let regex = "^4[0-9]{12}(?:[0-9]{3})?$"
        if (matchesRegex(regex: regex, text: numberOnly)) {
            return true
        }
        return false
    }
    
    func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }

}
