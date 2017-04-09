//
//  Globals.swift
//  Demo
//
//  Created by David Kong on 4/3/17.
//  Copyright © 2017 JAUNT INC. All rights reserved.
//

import Foundation
import UIKit

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height

let backgroundGray = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)
let buttonHighlightGray = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
let cardTextGray = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1)
let cardGray = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)

// KEYS: loggedInUser, location, uid, shortcode
let defaults = NSUserDefaults.standardUserDefaults()

// For redrawing views in the same controller
extension UIView {
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
