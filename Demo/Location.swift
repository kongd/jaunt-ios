//
//  Location.swift
//  SwiftSwipeView
//
//  Created by David Kong on 3/9/17.
//  Copyright © 2017 JAUNT INC. All rights reserved.


import Foundation

import MapKit
import UIKit

class Location: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
