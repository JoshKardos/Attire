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
}
