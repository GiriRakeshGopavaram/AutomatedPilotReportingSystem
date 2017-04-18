//
//  TestViewController.swift
//  AutomatedPIREP
//


//  Created by Pruthvi Parne on 10/28/16.
//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
//
import UIKit
import MapKit

class TAFsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate , UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var tafResults:[NSDictionary]!
    var propertiesToDisplay:[String:AnyObject] = [:]

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
                    tafResults = results
                    dispatch_async(dispatch_get_main_queue(), {
                        for eachObject in results{
                            
                            let geometry:[String:AnyObject] = eachObject["geometry"] as! [String:AnyObject]
                            var coordinates:[Double] = []
                            var latitude:Double
                            var longitude:Double
                            coordinates = geometry["coordinates"] as! [Double]
                            longitude = (coordinates[0])
                            latitude = (coordinates[1])
                            let location = CLLocationCoordinate2DMake(latitude, longitude)
                            let annotation = CustomPointAnnotation()
                            annotation.coordinate = location
                            annotation.title = "TAF"
                            annotation.subtitle = "Observed at \(latitude), \(longitude)"
                            self.mapView.addAnnotation(annotation)
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
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
 
        //for item in self.mapView.selectedAnnotations {
        if let annotation = view.annotation {
            let selectedLocation:CLLocationCoordinate2D = annotation.coordinate
            for eachObject in tafResults{
                let tafGeometry: [String:AnyObject]! = eachObject["geometry"] as! [String:AnyObject]
                let tafProperties:[String:AnyObject]! = eachObject["properties"] as! [String: AnyObject]
                var coordinates:[Double] = []
                var latitude:Double
                var longitude:Double
                coordinates = tafGeometry["coordinates"] as! [Double]
                longitude = (coordinates[0])
                latitude = (coordinates[1])
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                if location.latitude == selectedLocation.latitude && location.longitude == selectedLocation.longitude{
                    propertiesToDisplay = tafProperties
                }
            }
        }
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("displayTaf") as! DisplayTAFViewController
        popoverVC.modalPresentationStyle = .Popover
        //Configure the width, height of the pop over
        popoverVC.preferredContentSize = CGSizeMake(550, 300)
        popoverVC.properties = propertiesToDisplay
        // Present it before configuring it
        presentViewController(popoverVC, animated: true, completion: nil)
        // Now the popoverPresentationController has been created
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.FullScreen
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        //self.mapView.selectAnnotation(selectedAnnotation, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

