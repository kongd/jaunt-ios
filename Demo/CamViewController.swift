//
//  CamViewController.swift
//  Demo
//
//  Created by David Kong on 3/15/17.
//  Copyright © 2017 JAUNT INC. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CamViewController: UIViewController {
    
    @IBOutlet var cameraView: UIView!
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput() //incoming video feed
    var previewLayer = AVCaptureVideoPreviewLayer() //visible to user
    
    override func viewWillAppear(animated: Bool) {
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        
        for device in devices {
            if device.position == AVCaptureDevicePosition.Back {
                
                do {
                    let input = try AVCaptureDeviceInput (device:device as! AVCaptureDevice)
                    
                    if captureSession.canAddInput(input) {
                        captureSession.addInput(input)
                        
                        sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG] //for image
                        
                        if captureSession.canAddOutput(sessionOutput) {
                            captureSession.addOutput(sessionOutput)
                            captureSession.startRunning()
                            
                            //so user can see it
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            // resize feed to our view automatically
                            
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                            
                            cameraView.layer.addSublayer(previewLayer)
                            
                            previewLayer.position = CGPoint(x: 120, y: 0)
                            
                            previewLayer.bounds = UIScreen.mainScreen().bounds
                            
                            
                            
                        }
                        
                    }
                }
                
                catch {
                    //catch any potential errors...
                    
                }
            }
            
        }
    }
    @IBAction func takePhoto(sender: AnyObject) {
        
    }
    
}
