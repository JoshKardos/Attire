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
    var addressLine1: String?
    var postalCode: String?
    var city: String?
    var state: String?
    
    init(firstPaymentOption: STPPaymentOption) {
        let paymentMethodArr = firstPaymentOption.description.split(separator: ";")
        var expMonth = ""
        var expYear = ""
        var cardOwnerName = ""
        var addressLine1 = ""
        var city = ""
        var postalCode = ""
        var state = ""
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
            if ele.contains("line1") {
                let addressArr = ele.split(separator: " ")
                for i in 2..<addressArr.count {
                    addressLine1 = "\(addressLine1)\(addressArr[i]) "

                }
            }
            if ele.contains("city") {
               let cityArr = ele.split(separator: " ")
               for i in 2..<cityArr.count {
                   city = "\(city)\(cityArr[i]) "
               }
                city = city.trimmingCharacters(in: .whitespacesAndNewlines)
           }
            if ele.contains("postalCode") {
                let postalCodeArr = ele.split(separator: " ")
                postalCode = String(postalCodeArr[postalCodeArr.count - 1])
            }
            if ele.contains("state") {
                let stateArr = ele.split(separator: " ")
                state = String(stateArr[stateArr.count - 1])
            }

        }
        self.label = firstPaymentOption.label
        self.expMonth = expMonth
        self.expYear = expYear
        self.cardholderName = cardOwnerName
        self.addressLine1 = addressLine1
        self.city = city
        self.postalCode = postalCode
        self.state = state
    }
}
