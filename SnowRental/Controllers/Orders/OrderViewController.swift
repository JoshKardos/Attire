//
//  OrderViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/25/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import Kingfisher

class OrderViewController: UIViewController {

    var order: Order?
    @IBOutlet weak var designImageView: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var designIdLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    
    @IBOutlet weak var viewOrderDetailsContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.designImageView.kf.setImage(with: order?.imageURL)
        self.movieLabel.text = order?.design?.movieName
        self.designIdLabel.text = order?.designId
        self.orderDateLabel.text = order?.timestamp?.toMonthDayYear()
        
        viewOrderDetailsContainer.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewOrderDetailsContainer.layer.borderWidth = 1
        viewOrderDetailsContainer.layer.cornerRadius = 3
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewOrderDetailsContainer.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOrderDetails" {
            let vc = segue.destination as! OrderDetailsViewController
            vc.order = self.order
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "toOrderDetails", sender: nil)
    }
    


}
