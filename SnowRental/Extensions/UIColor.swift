//
//  UIColor.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/28/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    var hexString: String? {
        if self == UIColor.white {
            return "#FFFFFF"
        } else if self == UIColor.black {
            return "#000000"
        } else if self == UIColor.systemOrange {
            return "#FF9500"
        } else if self == UIColor.systemYellow {
            return "#FFCC00"
        } else if self == UIColor.systemGreen {
            return "#34C759"
        } else if self == UIColor.lightGray {
            return "#AAAAAA"
        } else if self == UIColor.systemPink {
            return "#FF2D55"
        }
        return nil
    }
    
}
