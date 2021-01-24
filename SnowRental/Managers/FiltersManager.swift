//
//  FiltersManager.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/17/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit

class FiltersManager {
    
    struct Filter {
        let filterName: String
        let nickName: String
        var filterEffectValue: Any?
        var filterEffectValueName: String?
        
        init(filterName: String, nickName: String, filterEffectValue: Any?, filterEffectValueName: String?) {
            self.nickName = nickName
            self.filterName = filterName
            self.filterEffectValue = filterEffectValue
            self.filterEffectValueName = filterEffectValueName
        }
    }
    
    // create filters func
    
        //takes slider value
        //creates the array to the bottom
    
    static let Filters: [Filter] = [
        Filter(filterName: "None", nickName: "None", filterEffectValue: nil, filterEffectValueName: nil),
        Filter(filterName: "CISepiaTone", nickName: "Sepia", filterEffectValue: 3, filterEffectValueName: kCIInputIntensityKey),
        Filter(filterName: "CIGaussianBlur", nickName: "Blur", filterEffectValue: 3, filterEffectValueName: kCIInputRadiusKey),
        Filter(filterName: "CICMYKHalftone", nickName: "Halftone", filterEffectValue: 25, filterEffectValueName: kCIInputWidthKey),
        Filter(filterName: "CICrystallize", nickName: "Crystallize", filterEffectValue: 45, filterEffectValueName: kCIInputRadiusKey)

    ]
    static var filter: CIFilter?
    static func applyFilterTo(image: UIImage, filterEffect: Filter, filterIntensity: Float?) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let context = CIContext(mtlDevice: MTLCreateSystemDefaultDevice()!)
        var filteredImage: UIImage? = image

        let ciImage = CIImage(cgImage: cgImage)
        filter = CIFilter(name: filterEffect.filterName)
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let intensity = filterIntensity {
            filter?.setValue(intensity * Float(filterEffect.filterEffectValue as! Int), forKey: filterEffect.filterEffectValueName!)
        } else {
            filter?.setValue(filterEffect.filterEffectValue, forKey: filterEffect.filterEffectValueName!)
        }
//        filter?.setDefaults()
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
            if let cgiImageResult = context.createCGImage(output, from: output.extent) {
                filteredImage = UIImage(cgImage: cgiImageResult)
            }
        }
        return filteredImage
    }
}
