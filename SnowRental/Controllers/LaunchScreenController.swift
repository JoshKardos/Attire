//
//  LaunchScreenController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/28/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit

class LaunchScreenController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("DIADS")
        UIView.animate(withDuration: 0.5, animations: {
            
            self.container.transform = CGAffineTransform(translationX: 0, y: -40)
        }) { (success) in
            UIView.animate(withDuration: 1.5, animations: {
                self.container.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
            }) { (success) in
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateInitialViewController()
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
        }
    }

}
