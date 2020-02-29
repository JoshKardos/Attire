//
//  OrderViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/19/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import Stripe
import FirebaseAuth
// this class is going to handle the checkout process
    // choosing card
    // shipping details
    // going through with payment
class ConfirmShirtViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shirtImageView: UIImageView!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var designImageView: UIImageView!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var designHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var designWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightSlider: UISlider!
    
    var design: Design?
    var movie: [String: Any]?
    var shirtColor: UIColor? = UIColor.white
    var imageURL: URL?
    var sizes = ["S", "M", "L", "XL"]
    
    var colors: [UIColor] = [
        UIColor.white,
        UIColor.black,
        UIColor.systemOrange,
        UIColor.systemYellow,
        UIColor.systemGreen,
        UIColor.lightGray,
//        UIColor.maroon,
        UIColor.systemPink
    ]
    
    var colorImageMap: [UIColor: UIImage?] = [
        UIColor.white: UIImage(named: "WhiteShirt"),
        UIColor.black: UIImage(named: "BlackShirt"),
        UIColor.systemOrange: UIImage(named: "OrangeShirt"),
        UIColor.systemYellow: UIImage(named: "YellowShirt"),
        UIColor.systemGreen: UIImage(named: "DarkGreenShirt"),
        UIColor.lightGray: UIImage(named: "GrayShirt"),
//        UIColor.maroon: UIImage(named: "MaroonShirt"),
        UIColor.systemPink: UIImage(named: "PinkShirt")
    ]

    var customerContext: STPCustomerContext?
    var paymentContext: STPPaymentContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = String(format: "$%.02f", Double(design!.price)/100)
        designImageView.kf.setImage(with: self.imageURL)
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
    }
    
    @IBAction func heightSliderChanged(_ sender: UISlider) {
        designHeightConstraint.constant = CGFloat(sender.value)
    }
    
    @IBAction func widthSliderChanged(_ sender: UISlider) {
        designWidthConstraint.constant = CGFloat(sender.value)
    }
    
    @IBAction func fitFillControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            designImageView.contentMode = .scaleToFill
        } else if sender.selectedSegmentIndex == 1 {
            designImageView.contentMode = .scaleAspectFill
        }
    }
    

    func configureData(design: Design, movie: [String: Any]) {
        guard let designUrl = design.imageUrl else {
            return
        }
        let url = URL(string: designUrl)
        self.imageURL = url
        self.design = design
        self.movie = movie
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCheckout" {
            let vc = segue.destination as! CheckoutShippingDetailsViewController
            vc.paymentContext = self.paymentContext
            guard let orderDesign = design, let orderMovie = movie, let orderShirtColor = shirtColor, let orderImageURL = imageURL, let uid = Auth.auth().currentUser?.uid else {
                print("order constructor failed")
                return
            }
            vc.order = Order(design: orderDesign, movie: orderMovie, shirtColor: orderShirtColor, imageUrl: orderImageURL, price: design!.price, size: sizes[sizeSegmentedControl.selectedSegmentIndex], userId: uid)
        }
    }
    
    @IBAction func checkoutPressed(_ sender: Any) {
        // check is logged in
        if Auth.auth().currentUser == nil {
            self.performSegue(withIdentifier: "ToAuthentication", sender: nil)
            return
        }
        
        let config = STPPaymentConfiguration()
        config.additionalPaymentOptions = .applePay
        config.shippingType = .shipping
        config.requiredBillingAddressFields = STPBillingAddressFields.full
        config.requiredShippingAddressFields = Set<STPContactField>(arrayLiteral: STPContactField.name, STPContactField.phoneNumber, STPContactField.postalAddress)
        config.companyName = "Testing XYZ"
        customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        paymentContext = STPPaymentContext(customerContext: customerContext!, configuration: config, theme: .default())
        self.paymentContext?.paymentAmount = design!.price // in cents
    
        // perform checkout storyboard
        self.performSegue(withIdentifier: "ToCheckout", sender: nil)
    }
    
}

extension ConfirmShirtViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
//        cell.frame.size.width = 30
//        cell.frame.size.height = 30
        cell.backgroundColor = colors[indexPath.row]
        if colors[indexPath.row] == UIColor.white {
            print("border")
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.lightGray.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = self.colorImageMap[self.colors[indexPath.row]] else {
            print("error with shirt color image")
            return
        }
        self.shirtImageView.image = image
        self.shirtColor = colors[indexPath.row]
    }
    
}
