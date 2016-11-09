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


    @IBOutlet weak var metOrbarb: MKMapView!
    //var jsonURL:String = "MetarJSON"
    
    @IBAction func metOrBarb(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0{
            
            //jsonURL = "MetarJSON"
            makeMetarRequest()
            
        }
        else if sender.selectedSegmentIndex == 1{
            //jsonURL = "TafJSON"
            makeWindRequest()

        }
    }
    @IBOutlet weak var pirepView: MKMapView!
    let locationManager  = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        pirepView.delegate = self
 
        
    }

    func makeMetarRequest(){
        let url = NSURL(string: "https://new.aviationweather.gov/gis/scripts/MetarJSON.php")
        
        // send out the request
        let session = NSURLSession.sharedSession()
        // implement completion handler
        session.dataTaskWithURL(url!, completionHandler: processResults).resume()
        
    }
    func makeWindRequest(){
        let url = NSURL(string: "https://new.aviationweather.gov/gis/scripts/TafJSON.php")
        
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
                                //let properties:[String:AnyObject] = eachObject["properties"] as! [String:AnyObject]
                                var coordinates:[Double] = []
                                var latitude:Double
                                var longitude:Double
                                coordinates = geometry["coordinates"] as! [Double]
                                longitude = (coordinates[0])
                                latitude = (coordinates[1])
                                let location = CLLocationCoordinate2DMake(latitude, longitude)
                                let annotation = CustomPointAnnotation()
                                annotation.coordinate = location
                                annotation.pinCustomImageName = UIImage(named: "Nil.png")
                                self.pirepView.addAnnotation(annotation)
                            
                            }
                        })
                   
                }
            }
            
            else {
                print("Anything?")
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
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = cpa.pinCustomImageName
        
        return anView
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

