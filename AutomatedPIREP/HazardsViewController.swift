//
//  TestViewController.swift
//  AutomatedPIREP
//


//  Created by Pruthvi Parne on 10/28/16.
//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

class HazardsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    var pinAnnotationView:MKPinAnnotationView!
    var overlayToShow : MKOverlay!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
                            let feature:[String:AnyObject] = eachObject["geometry"] as! [String:AnyObject]
                            //let properties:[String:AnyObject] = eachObject["properties"] as! [String:AnyObject]
                            let type = feature["type"] as! NSString
                            let coordinates = feature["coordinates"] as! NSArray
                            var pointsToPlot:[CLLocationCoordinate2D] = []
                            if type != "Point"{
                                if coordinates[0][0] as! NSArray! != nil{
                                    let cast = coordinates[0][0][0][0] as! NSNumber!
                                    var count = 0
                                    if cast != nil{
                                        for location in  0 ..< coordinates[0][0].count{
                                            let latitude = coordinates[0][0][location][0] as! Double
                                            let longitude = coordinates[0][0][location][1] as! Double
                                            pointsToPlot.append(CLLocationCoordinate2DMake(latitude,longitude))
                                            count += 1
                                        }
                                        let mutablePointsToPlot: UnsafeMutablePointer<CLLocationCoordinate2D> = UnsafeMutablePointer(pointsToPlot)
                                        self.overlayToShow = MKPolygon(coordinates: mutablePointsToPlot, count: count)
                                        self.mapView.addOverlay(self.overlayToShow)
                                    }
                                    else{
                                        //print(coordinates[0])
                                    }
                                }
                                else{
                                    print("Ooops!")
                                }
                            }
                            else{
                                print("I don't want a single location coordinate")
                            }
                        }
                        
                    })
                    
                }
            }
        }
        catch {
            
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.magentaColor()
            return polygonView
        }
        
        return nil
    }
  
}

