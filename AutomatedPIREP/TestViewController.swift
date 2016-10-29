//


//  TestViewController.swift


//  AutomatedPIREP


//


//  Created by Pruthvi Parne on 10/28/16.


//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.


//





import UIKit


import MapKit





class TestViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    
    let airportLocation = PIREPLocations.storeLocations()
    var pointAnnotation:CustomPointAnnotation!
    
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
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        for airport in airportLocation{
            let latitude = airport.latitude
            let longitude = airport.longitude
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
    
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        
        print(error.localizedDescription)
        
        
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation){
            return nil
        }
        let reuseIdentifier = "pin"
        
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        
        if annotationView == nil {
            
            print("nil")
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.image = UIImage(named: "pin.png")
            annotationView?.canShowCallout = true
            
            
        } else {
            
            print("full")
            annotationView!.annotation = annotation
            
            
        }
        
        return annotationView
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        
        
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    
    
    
    
    
    
    /*
     
     
     // MARK: - Navigation
     
     
     
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
     
     // Get the new view controller using segue.destinationViewController.
     
     
     // Pass the selected object to the new view controller.
     
     
     }
     
     
     */
    
    
    
    
    
}

