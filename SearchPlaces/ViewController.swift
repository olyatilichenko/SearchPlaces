//
//  ViewController.swift
//  SearchPlaces
//
//  Created by Olya Tilichenko on 27.02.2018.
//  Copyright © 2018 Olya Tilichenko. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapViewContainer: UIView!
    
    var googleMapView: GMSMapView!
    var locationManager: CLLocationManager!
    var placePicker: GMSPlacePicker!
    var latitude: Double!
    var longitude: Double!
    
    @IBAction func showSearchController(sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        self.googleMapView = GMSMapView(frame: self.mapViewContainer.frame)
        self.googleMapView.animate(toZoom: 18.0)
        self.view.addSubview(googleMapView)
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        
        let location:CLLocation = locations.last!
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
        let coordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        let marker = GMSMarker(position: coordinates)
        marker.title = "I am here"
        marker.map = self.googleMapView
        self.googleMapView.animate(toLocation: coordinates)
    }
   
}

