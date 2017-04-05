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
    
    var captureButton = UIButton()
    
    var deleteButton = UIButton()
    var sendButton = UIButton()
    
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
        captureButton.setTitle("Capture", forState: .Normal)
        captureButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        captureButton.frame = CGRectMake(15, -50, 325, 1050)
        captureButton.addTarget(self, action: #selector(CamViewController.captureImage(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(captureButton)
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
                
                //Create delete icon
                
                self.deleteButton = UIButton(frame: CGRectMake(20,20,30,30))
                self.deleteButton.addTarget(self, action: "deleteCapture:", forControlEvents: UIControlEvents.TouchUpInside)
                self.deleteButton.setImage(UIImage(named: "transparent_x.png"), forState: UIControlState.Normal)
                self.view.addSubview(self.deleteButton)
                
                //remove capture button
                self.captureButton.removeFromSuperview()
                
                //add send button
                self.sendButton = UIButton(frame: CGRectMake(0,530,400,75))
                self.sendButton.addTarget(self, action: "addToJaunt:", forControlEvents: UIControlEvents.TouchUpInside)
                self.sendButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
                self.sendButton.setTitle("Add to Jaunt", forState: UIControlState.Normal)
                self.view.addSubview(self.sendButton)
                
                
            })
        }
    }
    
    func deleteCapture(sender: UIButton) {
        print("delete pushed")
        self.deleteButton.removeFromSuperview()
        self.sendButton.removeFromSuperview()
        self.view.addSubview(captureButton)
        self.captureImageView.image = nil
        
    }
    
    func addToJaunt(sender: UIButton) {
        print("adding to Jaunt")
        
        if defaults.stringForKey("loggedInUser") == "" {
            let alert = UIAlertController(title: "Not Logged In", message: "You aren't logged in yet!", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Log In", style: UIAlertActionStyle.Default, handler:  {(action:UIAlertAction!) in self.goToLogin()
            }))
        }
        
        //write imageData to somewhere
        
        
    }
    
    func goToLogin() {
        self.pagingMenuViewController().setPosition(self.pagingMenuViewController().viewControllers!.count - 1, animated: true)
    }
}
