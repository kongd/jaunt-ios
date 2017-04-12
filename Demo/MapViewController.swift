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
        
        var locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        
        var currentLocation: CLLocation?
        currentLocation = locManager.location
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized){
            
            currentLocation = locManager.location
            
        }
        
//        label1.text = "\(currentLocation.coordinate.longitude)"
//        label2.text = "\(currentLocation.coordinate.latitude)"
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.mapView = MKMapView(frame: UIScreen.mainScreen().bounds)
        self.mapView?.showsUserLocation = true

        self.view.addSubview(self.mapView!)
        
        //42.29398, -83.71250
        
//        let london = Location(title: "2 Photos", coordinate: CLLocationCoordinate2D(latitude: 42.29398, longitude: -83.71250), info: "photo pin")
        
//        mapView!.addAnnotation(london)
        let currLoc = Location(title: "Current Location", coordinate: CLLocationCoordinate2D(latitude: TEST_LATITUDE, longitude: TEST_LONGITUDE), info: "user location")
        mapView!.addAnnotation(currLoc)
    }
    
    
    
}
