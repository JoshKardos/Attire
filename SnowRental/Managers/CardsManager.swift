//
//  CardsManager.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/25/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import Stripe


struct Card {
    var label: String?
    var expMonth: String?
    var expYear: String?
    var cardholderName: String?
    
    init(firstPaymentOption: STPPaymentOption) {
        let paymentMethodArr = firstPaymentOption.description.split(separator: ";")
        var expMonth = ""
        var expYear = ""
        var cardOwnerName = ""
        for ele in paymentMethodArr {
            if ele.contains("expMonth") {
                let monthArr = ele.split(separator: " ")
                let month = Int(monthArr[monthArr.count - 1])
                
                if month! < 10 {
                    expMonth = "0\(monthArr[monthArr.count - 1])"
                } else {
                    expMonth = "\(monthArr[monthArr.count - 1])"
                }
            }
            if ele.contains("expYear") {
                let yearArr = ele.split(separator: " ")
                expYear = String(yearArr[yearArr.count - 1])
            }
            if ele.contains("name") {
                let nameArr = ele.split(separator: " ")
                for i in 2..<nameArr.count {
                    cardOwnerName = "\(cardOwnerName)\(nameArr[i]) "

                }
            }

        }
        self.label = firstPaymentOption.label
        self.expMonth = expMonth
        self.expYear = expYear
        self.cardholderName = cardOwnerName
    }
}
