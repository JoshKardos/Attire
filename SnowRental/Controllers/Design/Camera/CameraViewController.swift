//
//  DesignViewController.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/16/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import ProgressHUD

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var libraryView: UIView!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        setupCaptureSession()
//        setupDevice()
//        setupInputOutput()
//        setupPreviewLayer()
        
        segmentedControl.selectedSegmentIndex = 0
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPreview" {
            let previewVC = segue.destination as! PreviewPhotoViewController
            if segmentedControl.selectedSegmentIndex == 0 {
                previewVC.image = DesignManager.imageFromLibrary
            } else {
                previewVC.image = self.image
            }
        } else if segue.identifier == "showLibrary" {
            print("show library")
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            if DesignManager.imageFromLibrary != nil {
                performSegue(withIdentifier: "toPhotoPreview", sender: nil)
            } else {
                ProgressHUD.showError("Must have a picture selected")
            }
        } else {
            performSegue(withIdentifier: "toPhotoPreview", sender: nil)
        }
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else  if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)

        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func stopRunningCaptureSession() {
        captureSession.stopRunning()
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        cameraButton.isEnabled = false
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func segmentedControlChnged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.configureLibraryView()
            break
        case 1:
            self.configureCameraView()
            break
        default:
            break
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.tabBarController!.selectedIndex = 0
        DesignManager.imageFromLibrary = nil
        image = nil
    }
    
    func configureCameraView() {
        cameraButton.isHidden = false
        cameraButton.isEnabled = true
        libraryView.isHidden = true
        nextBarButton.isEnabled = false
        startRunningCaptureSession()
    }
    
    func configureLibraryView() {
        cameraButton.isHidden = true
        cameraButton.isEnabled = false
        libraryView.isHidden = false
        nextBarButton.isEnabled = true
        stopRunningCaptureSession()
    }
    
}

extension CameraViewController : AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)
            cameraButton.isEnabled = true
            performSegue(withIdentifier: "toPhotoPreview", sender: nil)
        } else {
            cameraButton.isEnabled = true

        }
    }
}
