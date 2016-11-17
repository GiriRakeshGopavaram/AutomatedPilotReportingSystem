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


    //var jsonURL:String = "MetarJSON"
    
    @IBAction func metOrBarb(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0{
            
            //jsonURL = "MetarJSON"
            makeMetarRequest()
            pirepView.removeAnnotations(pirepView.annotations)
            
        }
        else if sender.selectedSegmentIndex == 1{
            //jsonURL = "TafJSON"
            makeWindRequest()
            pirepView.removeAnnotations(pirepView.annotations)

        }
    }
    @IBOutlet weak var pirepView: MKMapView!
    let locationManager  = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //locationManager.startUpdatingLocation()
        pirepView.delegate = self
 
        
    }

    func makeMetarRequest(){
        let url = NSURL(string: "http:/aviationweather.gov/gis/scripts/MetarJSON.php")
        
        // send out the request
        let session = NSURLSession.sharedSession()
        // implement completion handler
        session.dataTaskWithURL(url!, completionHandler: processMETARS).resume()
    }
    func makeWindRequest(){
        let url = NSURL(string: "http:/aviationweather.gov/gis/scripts/FBWindsJSON.php")
        
        // send out the request
        let session = NSURLSession.sharedSession()
        // implement completion handler
        session.dataTaskWithURL(url!, completionHandler: processWinds).resume()
    }
    
    func processMETARS(data:NSData?,response:NSURLResponse?,error:NSError?)->Void {
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
                                annotation.pinCustomImageName = UIImage(named: "Severe.png")
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
    
    func processWinds(data:NSData?,response:NSURLResponse?,error:NSError?)->Void {
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
                            
                            
                            let properties:[String:AnyObject] = eachObject["properties"] as! [String:AnyObject]
                            let windSpeedAsString:String = properties["wspd"] as! String
                            let windSpeed:Int? = Int(windSpeedAsString)
                            
                            let windDirectionAsString = properties["wdir"] as! String
                            let windDirection:Int? = Int(windDirectionAsString)
                            
                            let stationId = properties["id"] as! String
                            
                            if windSpeedAsString.containsString("nil"){
                                print("Sorry, I don't want a nil")
                            }
                            else{
                                
//                                for speed in 0 ... 18{
//                                    
//                                }
                                if (windSpeed!) < 1 {
                                    let windDirectionImage:UIImage = UIImage(named: "Calm")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                else if Int(windSpeed!) > 0 && Int(windSpeed!) < 3{
                                    let windDirectionImage:UIImage = UIImage(named: "1-2")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                else if Int(windSpeed!) > 2 && Int(windSpeed!) < 8{
                                    let windDirectionImage:UIImage = UIImage(named: "3-7")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                else if Int(windSpeed!) > 7 && Int(windSpeed!) < 13{
                                    let windDirectionImage:UIImage = UIImage(named: "8-12")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                else if Int(windSpeed!) > 12 && Int(windSpeed!) < 18{
                                    let windDirectionImage:UIImage = UIImage(named: "13-17")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                else if Int(windSpeed!) > 17 && Int(windSpeed!) < 23{
                                    let windDirectionImage:UIImage = UIImage(named: "18-22")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                else if Int(windSpeed!) > 22 && Int(windSpeed!) < 28{
                                    let windDirectionImage:UIImage = UIImage(named: "23-27")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                    
                                }
                                else if Int(windSpeed!) > 27 && Int(windSpeed!) < 33{
                                    let windDirectionImage:UIImage = UIImage(named: "28-32")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                    
                                }
                                else if Int(windSpeed!) > 32 && Int(windSpeed!) < 38{
                                    let windDirectionImage:UIImage = UIImage(named: "33-37")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                    
                                }
                                else if Int(windSpeed!) > 37 && Int(windSpeed!) < 43{
                                    let windDirectionImage:UIImage = UIImage(named: "38-42")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                    
                                }
                                else if Int(windSpeed!) > 42 && Int(windSpeed!) < 48{
                                    let windDirectionImage:UIImage = UIImage(named: "43-47")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                else if Int(windSpeed!) > 47 && Int(windSpeed!) < 53{
                                    let windDirectionImage:UIImage = UIImage(named: "48-52")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                else if Int(windSpeed!) > 52 && Int(windSpeed!) < 58{
                                    let windDirectionImage:UIImage = UIImage(named: "53-57")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                else if Int(windSpeed!) > 57 && Int(windSpeed!) < 63{
                                    let windDirectionImage:UIImage = UIImage(named: "58-62")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                else if Int(windSpeed!) > 62 && Int(windSpeed!) < 68{
                                    let windDirectionImage:UIImage = UIImage(named: "63-67")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                else if Int(windSpeed!) > 67 && Int(windSpeed!) < 73{
                                    let windDirectionImage:UIImage = UIImage(named: "68-72")!
                                    annotation.pinCustomImageName = windDirectionImage.imageRotatedByDegrees(CGFloat(windDirection!)+90, flip: false)
                                }
                                
                            }
                            annotation.title = "FB Winds over \(stationId)"
                            annotation.subtitle = "Winds:\(windDirection!) at \(windSpeed!) kt"
                            //annotation.subtitle = "WindSpeed \(windSpeed!)"
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
extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


