//
//  ViewController.swift
//  MishiPayCodeTest
//
//  Created by Shyam Bhudia on 06/09/2020.
//  Copyright © 2020 Shyam Bhudia. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController {
    //MARK: Global Variables
    var captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var barcodeView: UIView?
    var barcodeScanning = ""
    
    //MARK: Outlets
    @IBOutlet weak var mishiPayImageView: UIImageView!
    
    private let barcodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraScanning()
    }
    
    /**
     Setup Camera session for the barcode scanning
     */
    func setupCameraScanning() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back)
        guard let captureDevice = discoverySession.devices.first else {
            /// Alert user that they cannot use the camera move to a manual code entering screen
            print("Cannot find camera")
            return
        }
        
        do {
            //Set input on capture session
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(deviceInput)
            
            let metadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = barcodeTypes
            
        } catch {
            print("Error has occurred \(error.localizedDescription)")
        }
        initialiseVideoPreview()
    }
    
    /**
     Shows the scanning and camera feed to the user
     */
    func initialiseVideoPreview() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        self.previewLayer = previewLayer
        view.layer.addSublayer(previewLayer)
        view.bringSubviewToFront(mishiPayImageView)
        
        // Initialize QR Code Frame to highlight the QR code
        let barcodeFrameView = UIView()
                
        barcodeFrameView.layer.borderColor = UIColor.green.cgColor
        barcodeFrameView.layer.borderWidth = 2
        self.barcodeView = barcodeFrameView
        view.addSubview(barcodeFrameView)
        view.bringSubviewToFront(barcodeFrameView)
        
        captureSession.startRunning()

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.previewLayer?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        }, completion: nil)
    }
    
    func addToShoppingBag(object: String) {
        guard object != barcodeScanning else { return }
        if let viewController = storyboard?.instantiateViewController(identifier: "BasketViewController") as? BasketViewController {
            viewController.productScanned = object
            if navigationController?.topViewController is BasketViewController {
                return
            }
            self.navigationController?.pushViewController(viewController, animated: true)
            barcodeScanning = ""
        }
    }
}

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            /// Remove detection of the of barcode
            barcodeView?.frame = .zero
            return
        }
        
        guard let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        if barcodeTypes.contains(metadata.type) {
            let object = previewLayer?.transformedMetadataObject(for: metadata)
            barcodeView?.frame = object?.bounds ?? .zero
            // set bounds for detection
            if let objectValue = metadata.stringValue {
                // Add to shopping bag
                addToShoppingBag(object: objectValue)
            }
        }
    }
}
