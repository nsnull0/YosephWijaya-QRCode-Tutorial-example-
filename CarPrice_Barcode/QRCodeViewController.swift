//
//  QRCodeViewController.swift
//  CarPrice_Barcode
//
//  Created by Yoseph Wijaya on 2017/09/16.
//  Copyright © 2017 Yoseph Wijaya. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {

    @IBOutlet weak var inputName: UITextField!
    
    @IBOutlet weak var inputPrice: UITextField!
    
    @IBOutlet weak var inputQuantity: UITextField!
    
    @IBOutlet weak var inputQuality: UITextField!
    
    
    @IBOutlet weak var scannerView: UIView!
    
    
    @IBOutlet weak var resultName: UILabel!
    
    @IBOutlet weak var resultYen: UILabel!
    
    @IBOutlet weak var resultQuantity: UILabel!
    
    @IBOutlet weak var resultQuality: UILabel!
    
    
    @IBOutlet weak var InfoResult: UILabel!
    
    @IBOutlet weak var topPopUpConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var topPopUpStartConstraints: NSLayoutConstraint!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    var dataProduct:QRData{
        set{
            self.resultName.text =  newValue.name == "Unknown" ? newValue.name : ": \(newValue.name)"
            self.resultYen.text = newValue.price == "Unknown" ? newValue.price : ": \(newValue.price) 円"
            self.resultQuantity.text = newValue.quantity == "Unknown" ? newValue.quantity : ": \(newValue.quantity)"
            self.resultQuality.text = newValue.quality == "Unknown" ? newValue.quality : ": \(newValue.quality)/5"
            self.InfoResult.text = "\(newValue.qrcode)"
            if newValue.qrcode == "Unknown" {
                self.inputName.text = ""
                self.inputPrice.text = ""
                self.inputQuality.text = ""
                self.inputQuantity.text = ""
                UIView.animate(withDuration: 0.3, animations: {
                    self.topPopUpConstraints.constant = 0
                    self.view.layoutIfNeeded()
                })
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.topPopUpStartConstraints.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
        get {
            return QRData.notDetectedType()
        }
    }
    
    var valuatedDataProduct:QRData = QRData()
    
    
    lazy var QRCodeModel:QRCodeModelVIew = QRCodeModelVIew()
    
    override func viewDidLoad() {
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        
        do {
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = scannerView.layer.bounds
            
            videoPreviewLayer?.frame.origin.x = 25
            
            scannerView.layer.addSublayer(videoPreviewLayer!)
        }
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 1, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.topPopUpStartConstraints.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        detectArea()
        
    }
    
    func detectArea() {
        do{
            qrCodeFrameView?.removeFromSuperview()
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                scannerView.addSubview(qrCodeFrameView)
                scannerView.bringSubview(toFront: qrCodeFrameView)
            }
        }
    }
    
    
    @IBAction func startScanTouchUp(_ sender: UIButton) {
        detectArea()
        self.scannerView.layer.opacity = 1
        captureSession?.startRunning()
        UIView.animate(withDuration: 1, animations: {
            self.topPopUpStartConstraints.constant = -70
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func saveTouchUp(_ sender: UIButton) {
        self.view.endEditing(true)
        
        var newData:QRData = QRData()
        
        newData.name = self.inputName.text!
        newData.price = self.inputPrice.text!
        newData.quality = self.inputQuality.text!
        newData.quantity = self.inputQuantity.text!
        newData.qrcode = valuatedDataProduct.qrcode
        
        print("will saved qrcode \(valuatedDataProduct.qrcode)")
        
        _ = QRCodeModel.saveDataProduct(newData)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topPopUpConstraints.constant = -230
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.topPopUpStartConstraints.constant = 0
                self.view.layoutIfNeeded()
            })
            let alertVC:UIAlertController = UIAlertController(title: "Saving Item", message: "saved new item \(newData.qrcode)", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            
            self.present(alertVC, animated: true, completion: nil)
        }
        
        
        
    }
    
    @IBAction func cancelTouchUp(_ sender: UIButton) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.topPopUpConstraints.constant = -230
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.topPopUpStartConstraints.constant = 0
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
}


extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            
            dataProduct = QRData.notDetectedType()
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                print(metadataObj.stringValue)
                captureSession?.stopRunning()
                self.scannerView.layer.opacity = 0.5
                dataProduct = QRCodeModel.getQRData(qrCode: metadataObj.stringValue)
                valuatedDataProduct = QRCodeModel.getQRData(qrCode: metadataObj.stringValue)
                valuatedDataProduct.qrcode = metadataObj.stringValue
            }
        }

    }
}
