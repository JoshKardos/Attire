//
//  AddPaymentViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/19/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import ProgressHUD
class AddPaymentViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expDateMonthPicker: UIPickerView!
    @IBOutlet weak var expDateYearPicker: UIPickerView!
    var yearPickerOptions: [Int] = []
    var monthPickerOptions: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        for i in 0...20 {
            yearPickerOptions.append(year + i)
        }
        for i in 1...12 {
            monthPickerOptions.append(i)
        }
        expDateYearPicker.dataSource = self
        expDateMonthPicker.dataSource = self
        expDateYearPicker.delegate = self
        expDateMonthPicker.delegate = self
        
        cardNumberTextField.delegate = self

        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func addCardPressed(_ sender: Any) {
        if !validCard() {
            return
        }
    }
    func validCard() -> Bool{
        if nameTextField.text!.isEmpty || nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || cardNumberTextField.text!.isEmpty || cardNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            ProgressHUD.showError("There is an empty field")
            return false
        }
        print(cardNumberTextField.validateCreditCardFormat())
        return false
        
    }
}

extension AddPaymentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return true
        }
        textField.text = currentText.grouping(every: 4, with: " ")
        return false
    }
}

extension AddPaymentViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return monthPickerOptions.count
        }
        return yearPickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return String(monthPickerOptions[row])
        }
        return String(yearPickerOptions[row])
    }
    
    
}
