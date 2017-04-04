//
//  SettingsViewController.swift
//  Demo
//
//  Created by David Kong on 4/3/17.
//  Copyright © 2017 JAUNT INC. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        
        
        
        let sampleTextField = UITextField(frame: CGRectMake(20, 100, 300, 40))
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFontOfSize(15)
        sampleTextField.borderStyle = UITextBorderStyle.RoundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.No
        sampleTextField.keyboardType = UIKeyboardType.Default
        sampleTextField.returnKeyType = UIReturnKeyType.Done
        sampleTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        sampleTextField.delegate = self
        self.view.addSubview(sampleTextField)

    }
    
    func switchChanged(sender: UISwitch!) {
        print("Switch value is \(sender.on)")
        
        if (sender.on == false) {
            let alert = UIAlertController(title: "Location Tracking", message: "Users in this Jaunt will now be unable to see your location.", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            sendLocation = false
        } else {
            let alert = UIAlertController(title: "Location Tracking", message: "Users in this Jaunt will now be able to see your location. This may adversely affect battery life.", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            sendLocation = true
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    // MARK: Textfield Delegates <---
        
        
        
    
}
