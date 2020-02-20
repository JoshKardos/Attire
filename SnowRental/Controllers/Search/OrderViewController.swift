//
//  OrderViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/19/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import ChromaColorPicker

class OrderViewController: UIViewController, ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        self.color = color
    }
    @IBOutlet weak var colorPicker: ChromaColorPicker!
    @IBOutlet weak var colorView: UIView!
    
    var color: UIColor?
    override func viewDidLoad() {
        super.viewDidLoad()

        colorPicker.backgroundColor = view.backgroundColor
        colorPicker.delegate = self
        colorPicker.padding = 0
        colorPicker.stroke = 3
        colorPicker.hexLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
}
