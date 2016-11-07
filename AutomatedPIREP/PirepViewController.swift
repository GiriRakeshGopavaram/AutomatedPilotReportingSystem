//
//  FirstViewController.swift
//  AutomatedPIREP
//
//  Created by Gopavaram,Giri Rakesh on 10/13/16.
//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PirepViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

   @IBOutlet  weak var pirepView: MKMapView!
    
    let locationManager = CLLocationManager()
    let airportLocation = PIREPLocations.storeLocations()
    //var pointAnnotation:CustomPointAnnotation!
    //var pinAnnotationView:MKPinAnnotationView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        pirepView.delegate = self
        pirepView.mapType = MKMapType.Standard
        pirepView.showsUserLocation = true
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for airport in airportLocation{
            let latitude = airport.latitude
            let longitude = airport.longitude
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "PIREP"
            annotation.subtitle = "Extreme Turbulence at \(latitude), \(longitude)"
            
            pirepView.addAnnotation(annotation)
            
        }
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error.localizedDescription)
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> (MKAnnotationView?) {
        
        if (annotation is MKUserLocation){
            return nil
        }
        
        let reuseIdentifier = "pin"
        var annotationView1 = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
       // var annotationView2 = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        if annotationView1 == nil {
            annotationView1 = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView1?.image = UIImage(named: "ExtremeT.png")
            annotationView1?.canShowCallout = true
            
        } else {
            annotationView1!.annotation = annotation
        }

        return (annotationView1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

