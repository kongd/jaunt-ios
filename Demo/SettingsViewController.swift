//
//  SettingsViewController.swift
//  Demo
//
//  Created by David Kong on 4/3/17.
//  Copyright © 2017 JAUNT INC. All rights reserved.
//

import Foundation
import UIKit
import Firebase

var userTextField = UITextField()
var passTextField = UITextField()
var logoutButton = UIButton()

var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

var loginButton = UIButton()
var registrationButton = UIButton()

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    func buildSettingsView() {
        if defaults.stringForKey("loggedInUser") == "" {
            logoutButton.removeFromSuperview()
            
            userTextField = UITextField(frame: CGRectMake(20, 100, 350, 40))
            userTextField.placeholder = "email"
            userTextField.font = UIFont.systemFontOfSize(15)
            userTextField.borderStyle = UITextBorderStyle.RoundedRect
            userTextField.autocorrectionType = UITextAutocorrectionType.No
            userTextField.keyboardType = UIKeyboardType.EmailAddress
            userTextField.returnKeyType = UIReturnKeyType.Done
            userTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
            userTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            self.view.addSubview(userTextField)
            
            passTextField = UITextField(frame: CGRectMake(20, 160, 350, 40))
            passTextField.placeholder = "password"
            passTextField.font = UIFont.systemFontOfSize(15)
            passTextField.borderStyle = UITextBorderStyle.RoundedRect
            passTextField.autocorrectionType = UITextAutocorrectionType.No
            passTextField.keyboardType = UIKeyboardType.Default
            passTextField.returnKeyType = UIReturnKeyType.Done
            passTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
            passTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            passTextField.secureTextEntry = true
            passTextField.tag = 1
            passTextField.delegate = self
            self.view.addSubview(passTextField)
            
            loginButton = UIButton(frame: CGRectMake(20, 220, 165, 60))
            loginButton.setTitle("Log In", forState: UIControlState.Normal)
            loginButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            loginButton.layer.cornerRadius = 4.0
            loginButton.layer.borderWidth = 3.0
            loginButton.layer.borderColor = UIColor.greenColor().CGColor
            loginButton.addTarget(self, action: "loginUser:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(loginButton)
            
            registrationButton = UIButton(frame: CGRectMake(205, 220, 165, 60))
            registrationButton.setTitle("Register", forState: UIControlState.Normal)
            registrationButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            registrationButton.layer.cornerRadius = 4.0
            registrationButton.layer.borderWidth = 3.0
            registrationButton.layer.borderColor = UIColor.redColor().CGColor
            registrationButton.addTarget(self, action: "registerUser:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(registrationButton)
            
            
        } else {
            userTextField.removeFromSuperview()
            passTextField.removeFromSuperview()
            registrationButton.removeFromSuperview()
            loginButton.removeFromSuperview()
            
            logoutButton = UIButton(frame: CGRectMake(20, 100, 340, 60))
            logoutButton.setTitle("Log Out", forState: UIControlState.Normal)
            logoutButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            logoutButton.addTarget(self, action: "logoutUser:", forControlEvents: UIControlEvents.TouchUpInside)
            
            logoutButton.layer.cornerRadius = 4.0
            logoutButton.layer.borderWidth = 3.0
            logoutButton.layer.borderColor = UIColor.blueColor().CGColor
            self.view.addSubview(logoutButton)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        
        
        let frameView = UIView()
        frameView.frame = CGRectMake(0,0,SCREEN_WIDTH,100)
        view.addSubview(frameView)
        
        let privacySwitch = UISwitch()
        privacySwitch.center.y = frameView.center.y
        privacySwitch.center.x = SCREEN_WIDTH - 40
        privacySwitch.setOn(true, animated: false)
        privacySwitch.addTarget(self, action: #selector(switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(privacySwitch)
        
        let privacyLabel = UILabel()
        privacyLabel.attributedText = NSMutableAttributedString(string: "Location Tracking", attributes: [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)])
        privacyLabel.sizeToFit()
        privacyLabel.center.y = frameView.center.y
        view.addSubview(privacyLabel)
        
        buildSettingsView()
    }
    
    func logoutUser(sender: UIButton) {
        print ("logging out user")
        defaults.setObject("", forKey: "loggedInUser")
        buildSettingsView()
        
    }
    
    func switchChanged(sender: UISwitch!) {
        print("Switch value is \(sender.on)")
        
        if (sender.on == false) {
            let alert = UIAlertController(title: "Location Tracking", message: "Users in this Jaunt will now be unable to see your location.", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            defaults.setObject(false, forKey:"location")
        } else {
            let alert = UIAlertController(title: "Location Tracking", message: "Users in this Jaunt will now be able to see your location. This may adversely affect battery life.", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            defaults.setObject(true, forKey:"location")
        }
    }
    
    
    // MARK:- ---> Textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("TextField did end editing method called")
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    
    func loginUser(sender: UIButton) {
        FIRAuth.auth()?.signInWithEmail(userTextField.text!, password: passTextField.text!) { (user, error) in
            if let error = error {
                print (error)
                
                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler:  nil))
                userTextField.becomeFirstResponder()
            } else {
                print ("successfully login user")
                defaults.setObject((user?.email)!, forKey:"loggedInUser")
                
                self.buildSettingsView()
                
            }
        }
    }
    
    func firebaseRegisterUser() {
        print(userTextField.text!)
        print(passTextField.text!)
        
        let seconds = 4.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            FIRAuth.auth()?.createUserWithEmail(userTextField.text!, password: passTextField.text!) { (user, error) in
                if let error = error {
                    print (error)
                    
                    let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler:  nil))
                    userTextField.becomeFirstResponder()
                } else {
                    print ("successfully created user")
                    defaults.setObject((user?.email)!, forKey:"loggedInUser")
                    
                    self.buildSettingsView()
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSLog("############After login func")
                    activityIndicator.stopAnimating()
                    activityIndicator.hidden = true
                    activityIndicator.removeFromSuperview()
                })
            }
            
        })
        
        

    }
    
    func registerUser(sender: UIButton) {
        view.addSubview(activityIndicator)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            NSLog("################Before login func")
            self.firebaseRegisterUser()
        });
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();

        
        
        
        return true;
        
    }
    // MARK: Textfield Delegates <---
        
        
        
    
}
