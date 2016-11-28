//
//  TestViewController.swift
//  AutomatedPIREP
//


//  Created by Pruthvi Parne on 10/28/16.
//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
//
import UIKit
import MapKit

class HazardsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    
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
        makeRequest()
    }
    
    func makeRequest(){
        let url = NSURL(string: "http://aviationweather.gov/gis/scripts/HazardJSON.php")
        
        // send out the request
        let session = NSURLSession.sharedSession()
        // implement completion handler
        session.dataTaskWithURL(url!, completionHandler: processResults).resume()
        
    }
    
    func processResults(data:NSData?,response:NSURLResponse?,error:NSError?)->Void {
        do {
            
            // parse the data as dictionary first
            var jsonResult: NSDictionary?
            try jsonResult =  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            
            // now if jsonResult actually contains something
            if (jsonResult != nil) {
               
                if let results = jsonResult!["features"] as? [NSDictionary] {
                
                    dispatch_async(dispatch_get_main_queue(), {
                    
                        for eachObject in results {
                            
                            //print(eachObject["geometry"] as! String)
                            
                            if let geometry = eachObject["geometry"] as? NSDictionary{
                                if geometry["type"] as! String == "Point"{
                                let lineCoordinates = geometry["coordinates"]
                                print(lineCoordinates)
                                } else if geometry["type"] as! String == "Polygon" {
                                
                                    let polygonCoordinates = geometry["coordinates"]
                                    print(polygonCoordinates)
                                
                                } else if geometry["type"] as! String == "MultiPolygon"{
                                
                                    let multiPolygonCoordinates = geometry["coordinates"]
                                    print(multiPolygonCoordinates)
                                } else {
                                
                                 print(geometry["type"] as! String)
                                }
                            }
                            
                            
                            
                           
                        
                        }
                        
                    })
                
                }
            }
        }
        catch {
            
        }
        
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
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation){
            return nil
        }
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.image = UIImage(named: "warning")
            annotationView?.canShowCallout = true
            
        } else {
            print("full")
            annotationView!.annotation = annotation
        }
        
        return annotationView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

