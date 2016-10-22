//
//  SecondViewController.swift
//  AutomatedPIREP
//
//  Created by Gopavaram,Giri Rakesh on 10/13/16.
//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class METARSViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var pirepView: MKMapView!
    let locationManager  = CLLocationManager()
    let airportLocation = PIREPLocations.storeLocations()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.pirepView.showsUserLocation = true
        
        for airport in airportLocation{
            let latitude = airport.latitude
            let longitude = airport.longitude
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            pirepView.addAnnotation(annotation)
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
        let region = MKCoordinateRegionMake(center, MKCoordinateSpan(latitudeDelta: 95,longitudeDelta: 95))
        self.pirepView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors" + error.localizedDescription)
    }
    
    
}

