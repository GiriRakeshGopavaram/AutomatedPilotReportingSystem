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

class PirepViewController: UIViewController,CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    
    //: Below variables and outlets are used in this view controller
    @IBOutlet  weak var pirepView: MKMapView!
    var icaoId:String!
    var obsTime:String!
    var airepType:String!
    var aircraftType:String!
    var windSpeed:String!
    var windDirection:String!
    var flightLevel:String!
    var rawObservation:String!
    var temperature:String!
    let locationManager = CLLocationManager()
    var selectedAnnotationView:[Double]!
    var propertiesToDisplay:[String:AnyObject]!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        pirepView.delegate = self
        pirepView.mapType = MKMapType.Standard
        pirepView.showsUserLocation = true
        makeRequest()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func makeRequest(){
        let url = NSURL(string: "http://aviationweather.gov/gis/scripts/PirepJSON.php")
        // send out the request
        let session = NSURLSession.sharedSession()
        // implement completion handler
        session.dataTaskWithURL(url!, completionHandler: processResults).resume()
        
    }
    //Fetch JSO
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
                            var coordinates:[Double] = []
                            var latitude:Double
                            var longitude:Double
                            let annotation = CustomPointAnnotation()
                            let geometry:[String:AnyObject] = eachObject["geometry"] as! [String:AnyObject]
                            let properties = eachObject["properties"] as! [String:AnyObject]
                            
                            coordinates = geometry["coordinates"] as! [Double]
                            longitude = (coordinates[0])
                            latitude = (coordinates[1])
                            let location = CLLocationCoordinate2DMake(latitude, longitude)
                            annotation.coordinate = location
                            
                            let temperatures = properties["temp"]
                            let windSpeeds = properties["wspd"]
                            let windDirections = properties["wdir"]
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
                            
                            if self.selectedAnnotationView != nil{
                                
                                if String(annotation.coordinate.latitude) == String(format: "%.2f",self.selectedAnnotationView[0]){
                                    
                                    self.icaoId = (properties["icaoId"]) as! String
                                    self.obsTime = properties["obsTime"] as! String
                                    self.airepType = properties["airepType"] as! String
                                    self.aircraftType = properties["acType"] as! String
                                    self.flightLevel = properties["fltlvl"] as! String
                                    self.icaoId = rawObservation[rawObservation.startIndex ..< rawObservation.startIndex.advancedBy(3)]
                                    annotation.title = "\(rawObservation[rawObservation.startIndex ..< rawObservation.startIndex.advancedBy(3)])"
                                    
                                    self.rawObservation = rawObservation
                                    if String(temperatures).containsString("nil"){
                                        self.temperature = "Unknown"
                                    }
                                    else{
                                        self.temperature = temperatures as! String
                                    }
                                    if String(windSpeeds).containsString("nil"){
                                        self.windSpeed = "Unknown"
                                    }else{
                                        self.windSpeed = windSpeeds as! String
                                    }
                                    if String(windDirections).containsString("nil"){
                                        self.windDirection = "Unknown"
                                    }
                                    else{
                                        self.windDirection =  windDirections as! String
                                    }
                                    
                                }
                            }
                            self.pirepView.addAnnotation(annotation)
                            
                        }
                    })
                    
                }
            }
                
            else {
                print("What happened?")
            }
            
        }
        catch {
            print("Couldn't perofrm the operation")
        }
    }
    

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.FullScreen
    }

    
    
}

//: Extension with all the map view delegate methods.
extension PirepViewController : MKMapViewDelegate{
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "Location"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
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
        
        let latitude:Double! = mapView.selectedAnnotations.last?.coordinate.latitude
        let longitude:Double! = mapView.selectedAnnotations.last?.coordinate.longitude
        selectedAnnotationView = [latitude,longitude]
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("codePopover") as! DisplayTAFViewController
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
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
