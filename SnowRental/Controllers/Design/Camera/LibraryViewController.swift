//
//  LibraryViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/16/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import UIKit
import ProgressHUD

class LibraryViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var pickerController: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let imgFromLibrary = DesignManager.imageFromLibrary {
            imageView.image = imgFromLibrary
        } else {
            imageView.image = UIImage(systemName: "camera.fill")
        }
    }

    @IBAction func choosePressed(_ sender: Any) {
        pickerController = UIImagePickerController()
        pickerController.mediaTypes = ["public.image"]
        //access to extension
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
}

extension LibraryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if  let image = info[.originalImage] as? UIImage {
            imageView.image = image
            DesignManager.imageFromLibrary = image
        } else{
            ProgressHUD.showError("Error selecting photo... Please try again.")
        }
        dismiss(animated: true, completion: nil)
    }
}
