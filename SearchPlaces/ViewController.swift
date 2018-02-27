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
        
        let center = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        self.placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace { (place: GMSPlace?, error: Error?) -> Void in
            
            if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                let coordinates = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
                let marker = GMSMarker(position: coordinates)
                marker.title = place.name
                marker.map = self.googleMapView
                self.googleMapView.animate(toLocation: coordinates)
            } else {
                print("No place was selected")
            }
        }
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
    
    // MARK: Location protocol
    
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
    
    private func locationManager(manager: CLLocationManager,
                         didFailWithError error: Error){
        
        print("An error occurred while tracking location changes : \(error.localizedDescription)")
    }
   
}

