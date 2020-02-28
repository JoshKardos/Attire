//
//  String.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/19/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//
import Foundation

extension String {
    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
       let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
       return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
       }.joined().dropFirst())
    }
    
    func toMonthDayYear() -> String{
        var strDate = ""
        if let unixTime = Double(self) {
            let date = Date(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation() ?? "CET"  // get current TimeZone abbreviation or set to CET
            dateFormatter.timeZone = TimeZone(abbreviation: timezone) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MMMM dd, yyyy" //Specify your format that you want
            strDate = dateFormatter.string(from: date)
        }
        return strDate
    }
    func centsToDollarFormatted() -> String { // formatted means ready for didsplay // "$4.20"
        let _cents = Double(self)!
        let _dollars = _cents/100.0
        return String(format: "$%.02f", _dollars)
//        return self
    }
}
