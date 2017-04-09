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
import Alamofire

var loginCard = MaterialCard()
var loginButton = UIButton()
var registrationButton = UIButton()
var userTextField = UITextField()
var passTextField = UITextField()
var loginLabel = UILabel()

var privacyCard = MaterialCard()
let privacySwitch = UISwitch()
var privacyLabel = UILabel()

var jauntTextField = UITextField()

var activityIndicator = UIActivityIndicatorView()

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    func buildSettingsView() {
        print ("redrawing settings view...")
        if defaults.stringForKey("loggedInUser") == "" {
            view.removeAllSubviews()
            self.view.addSubview(activityIndicator)
            
            loginCard = MaterialCard(frame: CGRect(x: 0, y: 20, width: SCREEN_WIDTH, height: 230))
            self.view.addSubview(loginCard)
            
            loginLabel = UILabel(frame: CGRectMake(10, 0, SCREEN_WIDTH - 20, 40))
            loginLabel.font = UIFont.systemFontOfSize(22)
            loginLabel.text = "Account"
            loginCard.addSubview(loginLabel)
            
            userTextField = UITextField(frame: CGRectMake(10, 40, SCREEN_WIDTH - 20, 40))
            userTextField.placeholder = "email"
            userTextField.font = UIFont.systemFontOfSize(15)
            userTextField.borderStyle = UITextBorderStyle.RoundedRect
            userTextField.autocorrectionType = UITextAutocorrectionType.No
            userTextField.keyboardType = UIKeyboardType.EmailAddress
            userTextField.returnKeyType = UIReturnKeyType.Done
            userTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
            userTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            userTextField.delegate = self
            loginCard.addSubview(userTextField)
            
            passTextField = UITextField(frame: CGRectMake(10, 90, SCREEN_WIDTH - 20, 40))
            passTextField.placeholder = "password"
            passTextField.font = UIFont.systemFontOfSize(15)
            passTextField.borderStyle = UITextBorderStyle.RoundedRect
            passTextField.autocorrectionType = UITextAutocorrectionType.No
            passTextField.keyboardType = UIKeyboardType.Default
            passTextField.returnKeyType = UIReturnKeyType.Done
            passTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
            passTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            passTextField.secureTextEntry = true
            passTextField.delegate = self
            loginCard.addSubview(passTextField)
            
            loginButton = UIButton(frame: CGRectMake(10, 160, (SCREEN_WIDTH - 15 * 2) / 2, 60))
            loginButton.setTitle("Log In", forState: UIControlState.Normal)
            loginButton.setTitleColor(cardTextGray, forState: UIControlState.Normal)
            loginButton.layer.cornerRadius = 4.0
            loginButton.layer.borderWidth = 3.0
            loginButton.layer.borderColor = cardTextGray.CGColor
            loginButton.titleLabel?.font = UIFont.systemFontOfSize(20)
            loginButton.addTarget(self, action: "loginUser:", forControlEvents: UIControlEvents.TouchUpInside)
            loginCard.addSubview(loginButton)
            
            registrationButton = UIButton(frame: CGRectMake((SCREEN_WIDTH / 2) + 10 , 160, (SCREEN_WIDTH - 15 * 2) / 2, 60))
            registrationButton.setTitle("Register", forState: UIControlState.Normal)
            registrationButton.setTitleColor(cardTextGray, forState: UIControlState.Normal)
            registrationButton.layer.cornerRadius = 4.0
            registrationButton.layer.borderWidth = 3.0
            registrationButton.layer.borderColor = cardTextGray.CGColor
            registrationButton.titleLabel?.font = UIFont.systemFontOfSize(20)
            registrationButton.addTarget(self, action: "registerUser:", forControlEvents: UIControlEvents.TouchUpInside)
            loginCard.addSubview(registrationButton)
            
        } else {
            view.removeAllSubviews()
            self.view.addSubview(activityIndicator)
            
            privacyCard = MaterialCard(frame: CGRect(x: 0, y: 20, width: SCREEN_WIDTH, height: 80))
            self.view.addSubview(privacyCard)
            
            privacySwitch.center.y = privacyCard.center.y - 20
            privacySwitch.center.x = SCREEN_WIDTH - 30
            privacySwitch.setOn(true, animated: false)
            privacySwitch.addTarget(self, action: #selector(switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
            privacyCard.addSubview(privacySwitch)
            
            privacyLabel = UILabel(frame: CGRectMake(10, 0, SCREEN_WIDTH - 20, 40))
            privacyLabel.attributedText = NSMutableAttributedString(string: "Privacy", attributes: [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.systemFontOfSize(22)])
            privacyCard.addSubview(privacyLabel)
            
            let privacySubtext = UILabel(frame: CGRectMake(10, 25, SCREEN_WIDTH - 20, 40))
            privacySubtext.attributedText = NSMutableAttributedString(string: "Location Tracking", attributes: [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.systemFontOfSize(15)])
            privacyCard.addSubview(privacySubtext)
            
            let jauntCard = MaterialCard(frame: CGRect(x: 0, y: 120, width: SCREEN_WIDTH, height: 190))
            self.view.addSubview(jauntCard)
            jauntCard.removeAllSubviews()
            
            let jauntLabel = UILabel(frame: CGRectMake(10, 0, SCREEN_WIDTH - 20, 40))
            jauntLabel.attributedText = NSMutableAttributedString(string: "Your Jaunt", attributes: [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.systemFontOfSize(22)])
            jauntCard.addSubview(jauntLabel)
            
            print (defaults.stringForKey("shortcode")!)
            if (defaults.stringForKey("shortcode")! != "") {
                
                let jauntNameLabel = UILabel(frame: CGRectMake(10, 30, SCREEN_WIDTH - 20, 40))
                jauntNameLabel.attributedText = NSMutableAttributedString(string: "Current ongoing Jaunt: " + defaults.stringForKey("shortcode")!, attributes: [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.systemFontOfSize(15)])
                jauntCard.addSubview(jauntNameLabel)

                let leaveJauntButton = UIButton(frame: CGRectMake(10 , 110, (SCREEN_WIDTH - 15), 60))
                leaveJauntButton.setTitle("Leave Jaunt", forState: UIControlState.Normal)
                leaveJauntButton.setTitleColor(cardTextGray, forState: UIControlState.Normal)
                leaveJauntButton.layer.cornerRadius = 4.0
                leaveJauntButton.layer.borderWidth = 3.0
                leaveJauntButton.layer.borderColor = cardTextGray.CGColor
                leaveJauntButton.titleLabel?.font = UIFont.systemFontOfSize(20)
                leaveJauntButton.addTarget(self, action: "leaveJaunt:", forControlEvents: UIControlEvents.TouchUpInside)
                jauntCard.addSubview(leaveJauntButton)
                
                
            } else {
                jauntTextField = UITextField(frame: CGRectMake(10, 50, SCREEN_WIDTH - 20, 40))
                jauntTextField.placeholder = "jaunt name"
                jauntTextField.font = UIFont.systemFontOfSize(15)
                jauntTextField.borderStyle = UITextBorderStyle.RoundedRect
                jauntTextField.autocorrectionType = UITextAutocorrectionType.No
                jauntTextField.keyboardType = UIKeyboardType.Default
                jauntTextField.returnKeyType = UIReturnKeyType.Done
                jauntTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
                jauntTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
                jauntTextField.delegate = self
                jauntCard.addSubview(jauntTextField)
                
                let createJauntButton = UIButton(frame: CGRectMake(10, 110, (SCREEN_WIDTH - 15 * 2) / 2, 60))
                createJauntButton.setTitle("Create Jaunt", forState: UIControlState.Normal)
                createJauntButton.setTitleColor(cardTextGray, forState: UIControlState.Normal)
                createJauntButton.layer.cornerRadius = 4.0
                createJauntButton.layer.borderWidth = 3.0
                createJauntButton.layer.borderColor = cardTextGray.CGColor
                createJauntButton.titleLabel?.font = UIFont.systemFontOfSize(20)
                createJauntButton.addTarget(self, action: "createJaunt:", forControlEvents: UIControlEvents.TouchUpInside)
                jauntCard.addSubview(createJauntButton)
                
                let joinJauntButton = UIButton(frame: CGRectMake((SCREEN_WIDTH / 2) + 10 , 110, (SCREEN_WIDTH - 15 * 2) / 2, 60))
                joinJauntButton.setTitle("Join Jaunt", forState: UIControlState.Normal)
                joinJauntButton.setTitleColor(cardTextGray, forState: UIControlState.Normal)
                joinJauntButton.layer.cornerRadius = 4.0
                joinJauntButton.layer.borderWidth = 3.0
                joinJauntButton.layer.borderColor = cardTextGray.CGColor
                joinJauntButton.titleLabel?.font = UIFont.systemFontOfSize(20)
                joinJauntButton.addTarget(self, action: "joinJaunt:", forControlEvents: UIControlEvents.TouchUpInside)
                jauntCard.addSubview(joinJauntButton)
            }
            
            let logoutCard = MaterialCard(frame: CGRectMake(0, 330, SCREEN_WIDTH, 160))
            view.addSubview(logoutCard)
            
            let logoutLabel = UILabel(frame: CGRectMake(10, 0, SCREEN_WIDTH - 20, 40))
            logoutLabel.attributedText = NSMutableAttributedString(string: "Account", attributes: [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.systemFontOfSize(22)])
            logoutCard.addSubview(logoutLabel)
            
            let accountLabel = UILabel(frame: CGRectMake(10, 30, SCREEN_WIDTH - 20, 40))
            accountLabel.attributedText = NSMutableAttributedString(string: "Logged in as: " + defaults.stringForKey("loggedInUser")!, attributes: [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.systemFontOfSize(15)])
            logoutCard.addSubview(accountLabel)
            
            let logoutButton = UIButton(frame: CGRectMake(10, 80, SCREEN_WIDTH - 20, 60))
            logoutButton.setTitle("Log Out", forState: UIControlState.Normal)
            logoutButton.setTitleColor(cardTextGray, forState: UIControlState.Normal)
            logoutButton.addTarget(self, action: "logoutUser:", forControlEvents: UIControlEvents.TouchUpInside)
            logoutButton.titleLabel?.font = UIFont.systemFontOfSize(20)
            logoutButton.layer.cornerRadius = 4.0
            logoutButton.layer.borderWidth = 3.0
            logoutButton.layer.borderColor = cardTextGray.CGColor
            logoutCard.addSubview(logoutButton)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundGray
        
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.color = UIColor.blackColor()
        
        buildSettingsView()
    }
    
    // Jaunt join/create/delete
    func createJaunt(sender: UIButton) {
        print("creating jaunt...")
        let parameters = [
            "owner": defaults.objectForKey("uid")!
        ]
        
        Alamofire.request(.POST, "http://52.14.166.41:8000/api/jaunt/create/", parameters: parameters, encoding:.JSON).responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let response = JSON as! NSDictionary
                print(response)
                defaults.setObject(response["shortcode"], forKey: "shortcode")
                print(defaults)
                
                let alert = UIAlertController(title: "Jaunt created!", message: "You've now created the Jaunt '" + String(response["shortcode"]!) + "'. Give this code to your friends!", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in self.buildSettingsView()
                }))
                
                
                
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                let alert = UIAlertController(title: "Network Error", message: "Looks like something went very wrong.", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                }
        }
        
        jauntTextField.text = ""
        
    }
    
    func joinJaunt(sender: UIButton) {
        print("joining jaunt...")
        let entered_shortcode = jauntTextField.text!
        
        let parameters = [
            "user_id": defaults.objectForKey("uid")!,
            "shortcode": entered_shortcode
        ]
        
        Alamofire.request(.POST, "http://52.14.166.41:8000/api/jaunt/join/", parameters: parameters, encoding:.JSON).responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let response = JSON as! NSDictionary
//                print(String(response["error"])?)
                
                
                if let _ = response["error"]{
                    let alert = UIAlertController(title: "Jaunt not found!", message: "Please make sure that you've typed the name correctly.", preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                } else {
                    
                    defaults.setObject(entered_shortcode, forKey: "shortcode")
                    print (jauntTextField.text!)
                    let alert = UIAlertController(title: "Successfully joined Jaunt!", message: "You're now part of '" + entered_shortcode + "'."	, preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in self.buildSettingsView()
                    }))

                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                let alert = UIAlertController(title: "Network Error", message: "Looks like something went very wrong.", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                
                }
        }
        
        jauntTextField.text = ""
        buildSettingsView()
    }
    
    func leaveJaunt(sender: UIButton) {
        print("leaving jaunt...")
        defaults.setObject("", forKey: "shortcode")
        buildSettingsView()
    }
    
    
    // Logout
    func logoutUser(sender: UIButton) {
        print ("logging out user")
        defaults.setObject("", forKey: "loggedInUser")
        defaults.setObject("", forKey: "shortcode")
        defaults.setObject("", forKey: "uid")
//        defualts.setObject("", forKey: "location")
        buildSettingsView()
        
    }
    
    // Privacy
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
    
    //Login
    
    func firebaseLoginUser() {
        FIRAuth.auth()?.signInWithEmail(userTextField.text!, password: passTextField.text!) { (user, error) in
            if let error = error {
                print (error)
                
                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler:  nil))
                userTextField.becomeFirstResponder()
            } else {
                print ("successfully login user")
                defaults.setObject((user?.uid)!, forKey:"uid")
                defaults.setObject((user?.email)!, forKey:"loggedInUser")
                
                self.buildSettingsView()
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSLog("############After login func")
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
            activityIndicator.removeFromSuperview()
        })
    }
    
    func loginUser(sender: UIButton) {
        view.addSubview(activityIndicator)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            NSLog("################Before login func")
            self.firebaseLoginUser()
        });
    }
    
    
//    Registration
    func firebaseRegisterUser() {
        print(userTextField.text!)
        print(passTextField.text!)
        
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
                defaults.setObject((user?.uid)!, forKey:"uid")
                self.buildSettingsView()
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSLog("############After login func")
                activityIndicator.stopAnimating()
                activityIndicator.hidden = true
                activityIndicator.removeFromSuperview()
            })
        }
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
    
    
    // MARK:- ---> Textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
//        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
//        print("TextField did end editing method called")
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
//        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        print("TextField should snd editing method called")
        return true;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        print("TextField should return method called")
        textField.resignFirstResponder();
        
        return true;
        
    }
    // MARK: Textfield Delegates <---
        
        
        
    
}
