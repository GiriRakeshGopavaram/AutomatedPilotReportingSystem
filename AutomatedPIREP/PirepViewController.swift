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
        makeRequest()
    }
    
    
    func makeRequest(){
        let url = NSURL(string: "https://new.aviationweather.gov/gis/scripts/PirepJSON.php")
        
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
                // try parse it as array
                if let results = jsonResult!["features"] as? [NSDictionary] {
                    // get the information of each element in an array, each element is stored in a dictionary
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        for eachObject in results{
                            
                            let geometry:[String:AnyObject] = eachObject["geometry"] as! [String:AnyObject]
                            let properties:[String:AnyObject] = eachObject["properties"] as! [String:AnyObject]
                            let encodedPirep:String = properties["rawOb"] as! String
                            var coordinates:[Double] = []
                            var latitude:Double
                            var longitude:Double
                            coordinates = geometry["coordinates"] as! [Double]
                            longitude = (coordinates[0])
                            latitude = (coordinates[1])
                            if encodedPirep.containsString("TB "){
                                let turb = encodedPirep
                                if turb.containsString("SMOOTH") || turb.containsString("LGT-MOD"){
                                    let location = CLLocationCoordinate2DMake(latitude, longitude)
                                    let annotation = CustomPointAnnotation()
                                    annotation.coordinate = location
                                    annotation.pinCustomImageName = UIImage(named: "LightT.png")
                                    annotation.title = "PIREP"
                                    annotation.subtitle = turb
                                    self.pirepView.addAnnotation(annotation)
                                }
                                else if turb.containsString("MOD"){
                                    let location = CLLocationCoordinate2DMake(latitude, longitude)
                                    let annotation = CustomPointAnnotation()
                                    annotation.coordinate = location
                                    annotation.pinCustomImageName = UIImage(named: "ModerateT.png")
                                    annotation.title = "PIREP"
                                    annotation.subtitle = turb
                                    self.pirepView.addAnnotation(annotation)
                                }
                                else if turb.containsString("LGT"){
                                    let location = CLLocationCoordinate2DMake(latitude, longitude)
                                    let annotation = CustomPointAnnotation()
                                    annotation.coordinate = location
                                    annotation.pinCustomImageName = UIImage(named: "Nil.png")
                                    annotation.title = "PIREP"
                                    annotation.subtitle = turb
                                    self.pirepView.addAnnotation(annotation)
                                }
                              
                              
                            }
                            
                            
                        }
                    })
                    
                }
            }
                
            else {
                print("No results???")
            }
            
        }
        catch {
            
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "Location"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        annotationView!.image = cpa.pinCustomImageName
        
        return annotationView
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

