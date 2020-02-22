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
//    static let filterNicknames = [
//        "None",
////        "Halftone",
////        "Gaussian",
////        "Crystallize",
//        "Sepia"
//    ]
//    static let filterNames = [
//        "None",
////        "CICMYKHalftone",
////        "CIGaussianBlur",
////        "CICrystallize",
//        "CISepiaTone"
//    ]
    
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
    
    static let Filters: [Filter] = [
        Filter(filterName: "None", nickName: "None", filterEffectValue: nil, filterEffectValueName: nil),
        Filter(filterName: "CISepiaTone", nickName: "Sepia", filterEffectValue: 3, filterEffectValueName: kCIInputIntensityKey),
        Filter(filterName: "CIGaussianBlur", nickName: "Blur", filterEffectValue: 3, filterEffectValueName: kCIInputRadiusKey),
        Filter(filterName: "CICMYKHalftone", nickName: "Halftone", filterEffectValue: 25, filterEffectValueName: kCIInputWidthKey),
        Filter(filterName: "CICrystallize", nickName: "Crystallize", filterEffectValue: 45, filterEffectValueName: kCIInputRadiusKey)

    ]
    
    static var filteredImages: [String: UIImage] = [:]
    static var filter: CIFilter?
    
    static func removeData() {
        filteredImages.removeAll(keepingCapacity: false)
    }
    
    static func applyFilterTo(image: UIImage, filterEffect: Filter) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let context = CIContext(mtlDevice: MTLCreateSystemDefaultDevice()!)
        var filteredImage: UIImage? = image

        let ciImage = CIImage(cgImage: cgImage)
        filter = CIFilter(name: filterEffect.filterName)
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filterEffectValue = filterEffect.filterEffectValue, let filterEffectValueName = filterEffect.filterEffectValueName {
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage, let cgiImageResult = context.createCGImage(output, from: output.extent) {
            filteredImage = UIImage(cgImage: cgiImageResult)
        }
        
        do {
            try filteredImages[filterEffect.filterName] = filteredImage
            return filteredImage
        } catch {
            print("error with filters")
            return filteredImage
        }
    }
}
