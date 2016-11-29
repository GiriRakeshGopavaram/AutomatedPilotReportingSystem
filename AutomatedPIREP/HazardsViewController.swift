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
        drawShape()
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
                                    let pointCoordinates = geometry["coordinates"]
                                    print(pointCoordinates)
                                } else if geometry["type"] as! String == "Polygon" {
                                    
                                    let polygonCoordinate = geometry["coordinates"]
                                    let polygonCoordinates = polygonCoordinate as! [[[Double]]]
                                    
                                    print(polygonCoordinates.count)
                                    
//                                    for polygonCordinate in polygonCoordinates {
//                                    
//                                    
//                                    }
                                    
                                } else if geometry["type"] as! String == "MultiPolygon"{
                                    
                                    let multiPolygonCoordinate = geometry["coordinates"]
                                    let multiPolygonCoordinates = multiPolygonCoordinate as! [[[[Double]]]]
                                    
                                    print(multiPolygonCoordinates.count)
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
    
    
    func drawShape() {
        // Create a coordinates array to hold all of the coordinates for our shape.
        var coordinate = [
            CLLocationCoordinate2D(latitude: 45.522585, longitude: -122.685699),
            CLLocationCoordinate2D(latitude: 45.534611, longitude: -122.708873),
            CLLocationCoordinate2D(latitude: 45.530883, longitude: -122.678833),
            CLLocationCoordinate2D(latitude: 45.547115, longitude: -122.667503),
            CLLocationCoordinate2D(latitude: 45.530643, longitude: -122.660121),
            CLLocationCoordinate2D(latitude: 45.533529, longitude: -122.636260),
            CLLocationCoordinate2D(latitude: 45.521743, longitude: -122.659091),
            CLLocationCoordinate2D(latitude: 45.510677, longitude: -122.648792),
            CLLocationCoordinate2D(latitude: 45.515008, longitude: -122.664070),
            CLLocationCoordinate2D(latitude: 45.502496, longitude: -122.669048),
            CLLocationCoordinate2D(latitude: 45.515369, longitude: -122.678489),
            CLLocationCoordinate2D(latitude: 45.506346, longitude: -122.702007),
            CLLocationCoordinate2D(latitude: 45.522585, longitude: -122.685699),
            ]
        let polygon = MKPolygon(coordinates: &coordinate, count: 13)
        self.mapView.addOverlay(polygon)
        
 //       var  p = [MKPolygon polygonWithPoints:coordinates count:4];
//        CLLocationCoordinate2D coords[4] = {CLLocationCoordinate2DMake(40.5, -94.5),
//            CLLocationCoordinate2DMake(40.6, -94.3),
//            CLLocationCoordinate2DMake(40.5, -94.2),
//            CLLocationCoordinate2DMake(40.5, -94.5)};
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

