//
//  TestViewController.swift
//  AutomatedPIREP
//


//  Created by Pruthvi Parne on 10/28/16.
//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
//
import UIKit
import MapKit

class TAFsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let airportLocation = PIREPLocations.storeLocations()
    var annotation:CustomPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        mapView.showsUserLocation = true
        
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for airport in airportLocation{
            let latitude = airport.latitude
            let longitude = airport.longitude
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let annotation = CustomPointAnnotation()
            annotation.coordinate = location
            annotation.pinCustomImageName = "pin.png"
            annotation.title = "PIREP"
            annotation.title = "TAF at \(latitude), \(longitude)"
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            mapView.addAnnotation(pinAnnotationView.annotation!)
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error.localizedDescription)
    }
    
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        if (annotation is MKUserLocation){
//            return nil
//        }
//        
//        let reuseIdentifier = "pin"
//        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
//        
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//            annotationView?.image = UIImage(named: "pinny")
//            annotationView?.canShowCallout = true
//            
//        } else {
//            print("full")
//            annotationView!.annotation = annotation
//        }
//        
//        return annotationView
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

