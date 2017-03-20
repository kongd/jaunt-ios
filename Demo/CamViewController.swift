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
    
    var cameraView = UIView()
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput() //incoming video feed
    var previewLayer = AVCaptureVideoPreviewLayer() //visible to user
    var captureImageView = UIImageView() // displayed to user after taking a photo
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
                            
                            cameraView.frame = CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
                            self.view.addSubview(cameraView)
                            
                            cameraView.layer.addSublayer(previewLayer)
                            
                            
                            previewLayer.bounds = UIScreen.mainScreen().bounds
                            previewLayer.frame = CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
                            
                        }
                        
                    }
                }
                
                catch {
                    //catch any potential errors...
                    
                }
            }
        }
        
        //capture button
        
        let myFirstButton = UIButton()
        myFirstButton.setTitle("Capture", forState: .Normal)
        myFirstButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        myFirstButton.frame = CGRectMake(15, -50, 325, 1050)
        myFirstButton.addTarget(self, action: #selector(CamViewController.captureImage(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(myFirstButton)
    }
    
    func captureImage(sender: UIButton) {
        print("capturing image...")
        
        if let videoConnection = sessionOutput.connectionWithMediaType(AVMediaTypeVideo) {
            sessionOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                buffer, error in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                
                let dataProvider = CGDataProviderCreateWithCFData(imageData)
                let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider!, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                
                self.captureImageView.image = image
        
                self.captureImageView.frame = self.cameraView.frame
                self.cameraView.addSubview(self.captureImageView)
                
                print("writing image data to somewhere...")
                //write imageData to somewhere
            })
        }
    }
}
