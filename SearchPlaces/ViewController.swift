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
    
    var mapView: GMSMapView!
    
    var locationManager: CLLocationManager!
    var placePicker: GMSPlacePickerViewController!
    var latitude: Double!
    var longitude: Double!
    
    @IBAction func showSearchController(sender: AnyObject) {
        
        let center = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.012, center.longitude + 0.012)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.012, center.longitude - 0.012)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        
        self.placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
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
        self.mapView = GMSMapView(frame: self.mapViewContainer.frame)
        self.mapView.animate(toZoom: 14.2)
        self.view.addSubview(mapView)
    }
    // MARK: Location protocol
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        
        let location:CLLocation = locations.last!
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
        let coordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        let marker = GMSMarker(position: coordinates)
        let circle = GMSCircle(position: coordinates, radius: 1000)
        marker.title = "I am here"
        marker.map = self.mapView
        circle.map = self.mapView
        self.mapView.animate(toLocation: coordinates)
    }
    
    private func locationManager(manager: CLLocationManager,
                                 didFailWithError error: Error){
        
        print("An error occurred while tracking location changes : \(error.localizedDescription)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        NSLog("The place picker was canceled by the user")
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController: GMSPlacePickerViewControllerDelegate {
        
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        
        let coordinates = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
        let marker = GMSMarker(position: coordinates)
        marker.title = place.name
        marker.map = self.mapView
        self.mapView.animate(toLocation: coordinates)
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        // In your own app you should handle this better, but for the demo we are just going to log
        // a message.
        NSLog("An error occurred while picking a place: \(error)")
    }

    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        NSLog("The place picker was canceled by the user")
        
        // Dismiss the place picker.
        viewController.dismiss(animated: true, completion: nil)
    }
}
    


