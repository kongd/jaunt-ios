//
//  MapViewController.swift
//  Demo
//
//  Created by David Kong on 3/14/17.
//  Copyright © 2017 JAUNT INC. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var window: UIWindow?
    var mapView: MKMapView?
    
    override func viewDidLoad() {
        print("loading mapview")
        super.viewDidLoad()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.mapView = MKMapView(frame: UIScreen.mainScreen().bounds)
        self.view.addSubview(self.mapView!)
        
        //42.29398, -83.71250
        
        let london = Location(title: "2 Photos", coordinate: CLLocationCoordinate2D(latitude: 42.29398, longitude: -83.71250), info: "nothing")
        
        mapView!.addAnnotation(london)
    }
    
    
    
}
