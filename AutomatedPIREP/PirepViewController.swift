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

class PirepViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet  weak var pirepView: MKMapView!
    var point:CGPoint!
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
        let url = NSURL(string: "http://aviationweather.gov/gis/scripts/PirepJSON.php")
        
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
                            var coordinates:[Double] = []
                            var latitude:Double
                            var longitude:Double
                            coordinates = geometry["coordinates"] as! [Double]
                            longitude = (coordinates[0])
                            latitude = (coordinates[1])
                            let location = CLLocationCoordinate2DMake(latitude, longitude)
                            
                            let annotation = CustomPointAnnotation()
                            annotation.coordinate = location
                            annotation.title = "PIREP"
                            annotation.subtitle = "turb"
                            
                            let properties:[String:AnyObject] = eachObject["properties"] as! [String:AnyObject]
                            let rawObservation:String = properties["rawOb"] as! String
                            
                            let conditionsInRawOB = rawObservation.componentsSeparatedByString("/")
                            for condition in conditionsInRawOB{
                                if condition.containsString("TB "){
                                    switch true {
                                        
                                    case  condition.containsString("SMTH") || condition.containsString("SMOOTH"):
                                        annotation.pinCustomImageName = UIImage(named: "Smooth-LightT")
                                        break
                                    case condition.containsString("LGT ") || condition.containsString("LIGHT"):
                                        annotation.pinCustomImageName = UIImage(named: "LightT")
                                        break
                                    case condition.containsString("LGT-MOD") || condition.containsString("LIGHT TO MODERATE"):
                                        annotation.pinCustomImageName = UIImage(named:"Light-ModerateT" )
                                        break
                                    case condition.containsString("MOD") || condition.containsString("MODERATE") || condition.containsString("MDT"):
                                        annotation.pinCustomImageName = UIImage(named: "ModerateT")
                                        break
                                    case condition.containsString("MOD-SEV") || condition.containsString("MODERATE TO SEVERE"):
                                        annotation.pinCustomImageName = UIImage(named: "Moderate-SevereT")
                                        break
                                    case condition.containsString("SEV"):
                                        annotation.pinCustomImageName = UIImage(named: "SevereT")
                                        break
                                    case condition.containsString("EXTRM"):
                                        annotation.pinCustomImageName = UIImage(named: "ExtremeT")
                                        break
                                    case condition.containsString("NEG") || condition.containsString("NEGATIVE"):
                                        annotation.pinCustomImageName = UIImage(named: "NilT")
                                        break
                                    default:
                                        break
                                        
                                    }
                                    
                                }
                                else if condition.containsString("IC ") {
                                   
                                    annotation.title = "PIREP"
                                    annotation.subtitle = "icing"

                                    switch true {
                                    case condition.containsString("LGT ") || condition.containsString("LT "):
                                        annotation.pinCustomImageName = UIImage(named:"LightIC")
                                        break
                                    case condition.containsString("MOD ") || condition.containsString("MODERATE ") :
                                        annotation.pinCustomImageName = UIImage(named:"ModerateIC")
                                        break
                                    case condition.containsString("LGT-MOD ") :
                                        annotation.pinCustomImageName = UIImage(named: "Light-ModerateIC ")
                                        break
                                    case condition.containsString("TRACE ") :
                                        annotation.pinCustomImageName = UIImage(named: "TraceIC")
                                        break
                                    case condition.containsString("NEG ") :
                                        annotation.pinCustomImageName = UIImage(named: "NilIC")
                                        break
                                    case condition.containsString("SEV ") :
                                        annotation.pinCustomImageName = UIImage(named: "SevereIC")
                                        break
                                    case condition.containsString("MOD-SEV"):
                                        annotation.pinCustomImageName = UIImage(named: "Moderate-SevereIC")
                                        break
                                    default:
                                        break
                                    }
                                }
                            }
                            
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
    
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      
        let vc = storyboard.instantiateViewControllerWithIdentifier("popOver")
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
       
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        //popover.barButtonItem = sender
        popover.sourceView = mapView
       // popover.sourceRect = CGRect(x:0 ,y:0 ,width: 195, height: 195)
       
        popover.delegate = self
        presentViewController(vc, animated: true, completion:nil)
        
        
    }
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.None
//    }
    

    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}