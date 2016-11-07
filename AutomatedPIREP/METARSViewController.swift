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


    @IBAction func metOrBarb(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0{
           
           
        }
        else{
            
        }
    }
    @IBOutlet weak var pirepView: MKMapView!
    let locationManager  = CLLocationManager()
    let airportLocation = PIREPLocations.storeLocations()
    
    override func loadView() {
        super.loadView()
        makeRequest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        pirepView.delegate = self
        makeRequest()
   
        
    }

    func makeRequest(){
        let url = NSURL(string: "https://new.aviationweather.gov/gis/scripts/MetarJSON.php")
        
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
                            for r in results{
                            let gotIt:[String:AnyObject] = r as! [String : AnyObject]
                            let geometry:[String:AnyObject] = gotIt["geometry"] as! [String:AnyObject]
                                
                                    var coordinates:[Double] = []
                                var latitude:Double
                                    var longitude:Double
                                coordinates = geometry["coordinates"] as! [Double]
                               longitude = (coordinates[0])
                                latitude = (coordinates[1])
                            let location = CLLocationCoordinate2DMake(latitude, longitude)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = location
                            self.pirepView.addAnnotation(annotation)
                            
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

