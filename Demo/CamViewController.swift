//
//  CamViewController.swift
//  Demo
//
//  Created by David Kong on 3/15/17.
//  Copyright © 2017 JAUNT INC. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire
import UIKit
import FirebaseStorage
import Firebase

class CamViewController: UIViewController {
    
    var imageData = NSData()
    
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
        self.captureButton = UIButton(frame: CGRectMake(SCREEN_WIDTH / 2 - 50, SCREEN_HEIGHT - 200,100,100))
        self.captureButton.addTarget(self, action: "captureImage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.captureButton.setImage(UIImage(named: "test-again.png"), forState: UIControlState.Normal)
        self.view.addSubview(self.captureButton)
    }
    
    func captureImage(sender: UIButton) {
        print("capturing image...")
        
        if let videoConnection = sessionOutput.connectionWithMediaType(AVMediaTypeVideo) {
            sessionOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                buffer, error in
                self.imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                
                let dataProvider = CGDataProviderCreateWithCFData(self.imageData)
                let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider!, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                
                self.captureImageView.image = image
        
                self.captureImageView.frame = self.cameraView.frame
                self.cameraView.addSubview(self.captureImageView)
                
                print("writing image data to somewhere...")
                
                //Create delete icon
                
                self.deleteButton = UIButton(frame: CGRectMake(20,20,30,30))
                self.deleteButton.addTarget(self, action: "deleteCapture:", forControlEvents: UIControlEvents.TouchUpInside)
                self.deleteButton.setImage(UIImage(named: "transparent_x.png"), forState: UIControlState.Normal)
                self.view.addSubview(self.deleteButton)
                
                //remove capture button
                self.captureButton.removeFromSuperview()
                
                //add send button
                self.sendButton = UIButton(frame: CGRectMake(0,530,SCREEN_WIDTH,75))
                self.sendButton.addTarget(self, action: "addToJaunt:", forControlEvents: UIControlEvents.TouchUpInside)
                self.sendButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
                self.sendButton.setTitle("Add to Jaunt", forState: UIControlState.Normal)
                self.sendButton.titleLabel?.font = UIFont.systemFontOfSize(25)
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
            alert.addAction(UIAlertAction(title: "Log In", style: UIAlertActionStyle.Default, handler:  {(action:UIAlertAction!) in self.goToSettings()
            }))
        } else if defaults.stringForKey("shortcode") == "" {
            let alert = UIAlertController(title: "Not in a Jaunt", message: "You haven't joined a Jaunt yet!", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Join Jaunt", style: UIAlertActionStyle.Default, handler:  {(action:UIAlertAction!) in self.goToSettings()
            }))
        } else {
//            Upload to firebase
            let storage = FIRStorage.storage()
            let storageRef = storage.reference()
            
            
            // Create file metadata to update
            let newMetadata = FIRStorageMetadata()
            newMetadata.contentType = "image/jpeg";
            
            // Create a reference to the file you want to upload
            let randomName = randomStringWithLength(10)
            let imageRef = storageRef.child("images/" + (randomName as String) + ".jpg")
            
            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = imageRef.putData(imageData, metadata: newMetadata) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL
            }
            
            uploadTask.observeStatus(FIRStorageTaskStatus.Success, handler: { (snapshot) in
                print ("upload success!")
                
                let alert = UIAlertController(title: "Photo uploaded!", message: "Upload success!", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in self.resetCameraView()
                }))
                
                // get user, then post to api/photo
                self.updateServer(randomName as String)
                
            })
            
            uploadTask.observeStatus(FIRStorageTaskStatus.Failure, handler: { (snapshot) in
                print ("upload failure...")
                print (snapshot.error)
//                if let error = snapshot.error as! NSError {
//                    switch (FIRStorageErrorCode(rawValue: error.code)!) {
//                    case .objectNotFound:
//                        // File doesn't exist
//                        print ("file does not exist")
//                        break
//                    case .unauthorized:
//                        // User doesn't have permission to access file
//                        print ("user has no permissions")
//                        break
//                    case .cancelled:
//                        // User canceled the upload
//                        break
//                        
//                        /* ... */
//                        
//                    case .unknown:
//                        // Unknown error occurred, inspect the server response
//                        print ("unknown error")
//                        break
//                    default:
//                        // A separate error occurred. This is a good place to retry the upload.
//                        print ("other error")
//                        break
//                    }
//                }
            })
        }
    }
    
    func updateServer(randomString: String) {
        print ("updating on our server...")
        
//        Get user's jaunt id
        
        Alamofire.request(.GET, "http://52.14.166.41:8000/api/user/" + defaults.stringForKey("uid")! + "/", parameters: nil, encoding:.JSON).responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                
                let response = JSON as! NSDictionary
                print(response)
                defaults.setObject(response["current_jaunt"], forKey: "jauntid")
                
                
                
                
                // Post to db, with photo info
                let path_name = ("/images/" + randomString + ".jpg")
                print ("jauntid")
                print (defaults.integerForKey("jauntid"))
                let parameters : [String : AnyObject] = [
                    "owner": defaults.stringForKey("uid")!,
                    "jaunt_id": defaults.integerForKey("jauntid"),
                    "original_path": path_name,
                    "latitude": TEST_LATITUDE,
                    "longitude": TEST_LONGITUDE
                ]
                
                Alamofire.request(.POST, "http://52.14.166.41:8000/api/photo/", parameters: parameters, encoding:.JSON).responseJSON
                    { response in switch response.result {
                    case .Success(let JSON):
                        
                        let response = JSON as! NSDictionary
                        print(response)
                        
                        print ("actually completed upload operations")
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        let alert = UIAlertController(title: "Network Error", message: "Looks like something went wrong.", preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alert, animated: true, completion: nil)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        }
                }

                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                let alert = UIAlertController(title: "Network Error", message: "Looks like something went wrong.", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                }
        }
        
        
        
        
        
    }
    
    func resetCameraView() {
        deleteButton.removeFromSuperview()
        sendButton.removeFromSuperview()
        captureImageView.removeFromSuperview()
        
        
        self.view.addSubview(captureButton)
    }
    
    func goToSettings() {
        self.pagingMenuViewController().setPosition(self.pagingMenuViewController().viewControllers!.count - 1, animated: true)
//        self.pagingMenuViewController().delegate
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }

}
