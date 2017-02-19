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

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}
class HazardsViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    let locationManager = CLLocationManager()
    var pinAnnotationView:MKPinAnnotationView!
    var overlayToShow : MKOverlay!
    var colorToFill:String = ""
    var startingLoc:CLLocationCoordinate2D!
    var destinationLoc:CLLocationCoordinate2D!
    var count = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let locationSearchTable:LocationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        
        locationSearchTable.handleMapSearchDelegate = self
        definesPresentationContext = true
        makeRequest()
        
        
    }
    
    //This function helps in drawing the lines across the mapview with respect to latitude and longitude.
    func drawLines(latitude:Double, longitude:Double){
        if mapView.annotations.count == 0 {
            startingLoc = CLLocationCoordinate2D()
            startingLoc.latitude = latitude
            startingLoc.longitude = longitude
        }
        else if mapView.annotations.count == 1{
            
            destinationLoc = CLLocationCoordinate2D()
            destinationLoc.latitude = latitude
            destinationLoc.longitude = longitude
        }
        
        if startingLoc != nil && destinationLoc != nil{

            let sourceLocation:CLLocationCoordinate2D! = startingLoc
            let destinationLocation:CLLocationCoordinate2D! = destinationLoc
            // 3.
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
            
            // 4.
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            // 5.
            let sourceAnnotation = MKPointAnnotation()
            
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
            }
            
            
            let destinationAnnotation = MKPointAnnotation()
            
            if let location = destinationPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate
            }
            
            // 6.
            self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
            
            // 7.
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .Automobile
            
            // Calculate the direction
            let directions = MKDirections(request: directionRequest)
            
            // 8.
            directions.calculateDirectionsWithCompletionHandler {
                (response, error) -> Void in
                
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    
                    return
                }
                
                let route = response.routes[0]
                self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
            
        }
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
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
                            let properties:[String:AnyObject] = eachObject["properties"] as! [String:AnyObject]
                            if let color = properties["color"]{
                                let colorAsString : String = "\(color)"
                                self.colorToFill = colorAsString
                            }
                            let type = feature["type"] as! NSString
                            let coordinates = feature["coordinates"] as! NSArray
                            var pointsToPlot:[CLLocationCoordinate2D] = []
                            if type != "Point"{
                                if coordinates[0][0] as! NSArray! != nil{
                                    let cast = coordinates[0][0][0][0] as! NSNumber!
                                    var count = 0
                                    if cast != nil{
                                        for location in  0 ..< coordinates[0][0].count{
                                            let latitude = coordinates[0][0][location][1] as! Double
                                            let longitude = coordinates[0][0][location][0] as! Double
                                            pointsToPlot.append(CLLocationCoordinate2DMake(latitude,longitude))
                                            count += 1
                                        }
                                        let mutablePointsToPlot: UnsafeMutablePointer<CLLocationCoordinate2D> = UnsafeMutablePointer(pointsToPlot)
                                        self.overlayToShow = MKPolygon(coordinates: mutablePointsToPlot, count: count)
                                        self.mapView.addOverlay(self.overlayToShow)
                                    }
                                    else{
                                        for location in  0 ..< coordinates[0].count{
                                            let latitude = coordinates[0][location][1] as! Double
                                            let longitude = coordinates[0][location][0] as! Double
                                            pointsToPlot.append(CLLocationCoordinate2DMake(latitude,longitude))
                                            count += 1
                                        }
                                        let mutablePointsToPlot: UnsafeMutablePointer<CLLocationCoordinate2D> = UnsafeMutablePointer(pointsToPlot)
                                        self.overlayToShow = MKPolygon(coordinates: mutablePointsToPlot, count: count)
                                        self.mapView.addOverlay(self.overlayToShow)

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
            polygonView.fillColor = hexStringToUIColor(self.colorToFill)

            return polygonView
        }
        else{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.redColor()
            renderer.lineWidth = 4.0
            
            return renderer
        }
        
        return nil
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}



extension HazardsViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        let annotation = MKPointAnnotation()
        
        if mapView.annotations.count == 1{
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state) -- Destination"
                drawLines(annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                
            }
            mapView.addAnnotation(annotation)
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            mapView.setRegion(region, animated: true)
            
            let alert:UIAlertController = UIAlertController(title: "Do you want to use this as your destination location?", message: "" , preferredStyle: .Alert)
            let defaultAction:UIAlertAction =  UIAlertAction(title: "Yes", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            let noAction:UIAlertAction = UIAlertAction(title:"No", style: .Cancel, handler: nil)
            alert.addAction(noAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        else if mapView.annotations.count == 0{
            
            mapView.removeAnnotations(mapView.annotations)
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state) -- Starting Location"
                drawLines(annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                
            }
            mapView.addAnnotation(annotation)
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            mapView.setRegion(region, animated: true)
            
            let alert:UIAlertController = UIAlertController(title: "Do you want to use this as your current location?", message: "" , preferredStyle: .Alert)
            let defaultAction:UIAlertAction =  UIAlertAction(title: "Yes", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            let noAction:UIAlertAction = UIAlertAction(title:"No", style: .Cancel, handler: nil)
            alert.addAction(noAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
}


