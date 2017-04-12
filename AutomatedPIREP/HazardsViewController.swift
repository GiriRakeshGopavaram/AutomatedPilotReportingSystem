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
    
    var appDelegate:AppDelegate!
    
    var tafLocations:[CLLocationCoordinate2D]! = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    var icaoID:String!
    
    var resultSearchController:UISearchController? = nil
    
    var selectedPin:MKPlacemark? = nil
    
    let locationManager = CLLocationManager()
    
    var pinAnnotationView:MKPinAnnotationView!
    
    var overlayToShow : MKOverlay!
    
    var colorToFill:String = ""
    
    var startingLoc:CLLocation!
    
    var destinationLoc:CLLocation!
    
    var count = 0
    
    var product = ""
    
    var hazard = ""
    
    var level = ""
    
    var validTime = ""
    
    var top = ""
    
    var base = ""
    
    var fzlbase = ""
    
    var fzltop = ""
    
    var severity = ""
    
    var dueTo = ""
    
    var userSourceLocation = CLLocation()
    var userDestinationLocation = CLLocation()
    
    var nearestDistance:CLLocationDistance!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        let g = Geotification(coordinate: location.1, radius: CLLocationDistance(8046.72), note: "test", eventType: EventType.OnEntry)
//        startMonitoringGeotification(g)
        
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
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
        
        //mapView.showsUserLocation = true
        
        
        
        locationSearchTable.handleMapSearchDelegate = self
        
        definesPresentationContext = true
        getRequest()
        makeRequest()
    }
    
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "Yes", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        let noAction:UIAlertAction = UIAlertAction(title:"No", style: .Cancel, handler: nil)
        alert.addAction(noAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //This function helps in drawing the lines across the mapview with respect to latitude and longitude.
    
    func drawLines(latitude:Double, longitude:Double){
        
        if mapView.annotations.count == 0 {
            
            startingLoc = CLLocation(latitude: latitude, longitude: longitude)
            
        }
            
        else if mapView.annotations.count == 1{
            
            destinationLoc = CLLocation(latitude: latitude, longitude: longitude)
            
        }
        
        
        if startingLoc != nil && destinationLoc != nil{
            userSourceLocation = startingLoc
            userDestinationLocation = destinationLoc
            
            var coordinates = [startingLoc.coordinate, destinationLoc.coordinate]
            let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
            for count in 0 ..< geodesicPolyline.pointCount{
            }
            mapView.addOverlay(geodesicPolyline)
            
            for airport in appDelegate.nearestAirports(startingLoc, destination: destinationLoc) {
                var coordinates = [startingLoc.coordinate, airport.coordinate, destinationLoc.coordinate]
                let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 3)
                mapView.addOverlay(geodesicPolyline)
            }
            
            let sourceAnnotation = MKPointAnnotation()
            let destinationAnnotation = MKPointAnnotation()
            
            
            self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
            
        }
        
    }
    
    func userInsidePolygon(userlocation: CLLocationCoordinate2D ) -> Bool{
        // get every overlay on the map
        let o = self.mapView.overlays
        // loop every overlay on map
        for overlay in o {
            // handle only polygon
            if overlay is MKPolygon{
                let polygon:MKPolygon =  overlay as! MKPolygon
                let polygonPath:CGMutablePathRef  = CGPathCreateMutable()
                // get points of polygon
                let arrPoints = polygon.points()
                // create cgpath
                for i in 0 ..< polygon.pointCount{
                    let polygonMapPoint: MKMapPoint = arrPoints[i]
                    let polygonCoordinate = MKCoordinateForMapPoint(polygonMapPoint)
                    let polygonPoint = self.mapView.convertCoordinate(polygonCoordinate, toPointToView: self.mapView)
                    
                    if (i == 0){
                        CGPathMoveToPoint(polygonPath, nil, polygonPoint.x, polygonPoint.y)
                    }
                    else{
                        CGPathAddLineToPoint(polygonPath, nil, polygonPoint.x, polygonPoint.y)
                    }
                }
                let mapPointAsCGP:CGPoint = self.mapView.convertCoordinate(userlocation, toPointToView: self.mapView)
                
            }
        }
        return false
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            
            locationManager.requestLocation()
            
        }
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("error:: \(error)")
        
    }
    
 
    
    
    // 1. user enter region
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //showAlert("enter \(region.identifier)")
    }
    
    
    
    func getRequest(){
        let url = NSURL(string: "https://new.aviationweather.gov/gis/scripts/TafJSON.php")
        
        // send out the request
        let session = NSURLSession.sharedSession()
        // implement completion handler
        session.dataTaskWithURL(url!, completionHandler: getResults).resume()
        
    }
    
    func getResults(data:NSData?,response:NSURLResponse?,error:NSError?)->Void {
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
                            self.icaoID = properties["id"] as! String
                            var coordinates:[Double] = []
                            var latitude:Double
                            var longitude:Double
                            coordinates = geometry["coordinates"] as! [Double]
                            longitude = (coordinates[0])
                            latitude = (coordinates[1])
                            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            self.tafLocations.append(location)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = location
                            annotation.title = "TAF"
                            annotation.subtitle = "Observed at \(latitude), \(longitude)"
                            
                            
                            // 3. setup region
                        
                            
                            
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
    
    func checkForTafs(icaoID:String, userSourceLocation:CLLocation, userDestinationLocation:CLLocation){
        var locations = [userSourceLocation.coordinate, userDestinationLocation.coordinate]
        let geodesicPolyline = MKGeodesicPolyline(coordinates: &locations, count: 2)
        var annotations:[MKAnnotation] = []
        for count in 0 ..< geodesicPolyline.pointCount{
            if count != 10{
                let location:CLLocationCoordinate2D = MKCoordinateForMapPoint(geodesicPolyline.points()[count])
                let regionradius = CLLocationDistance(40233.6/25)
                let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: location.latitude,
                    longitude: location.longitude), radius: regionradius, identifier: icaoID )
                self.locationManager.startMonitoringForRegion(region)
                for everyLocation in tafLocations{
                    if region.containsCoordinate(everyLocation){
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = everyLocation
                        annotations.append(annotation)
                        self.mapView.addAnnotation(annotation)
                        
                    }
                }
                self.locationManager.stopMonitoringForRegion(region)
            }
        }
        //self.mapView.showAnnotations(annotations, animated: true)
    }
    func makeRequest(){
        
        let url = NSURL(string: "http://aviationweather.gov/gis/scripts/GairmetJSON.php")
        
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
                            
                            self.product = properties["product"] as! String
                            
                            self.hazard = properties["hazard"] as! String
                            
                            if properties["level"]  != nil {
                                
                                self.level = properties["level"] as! String
                                
                            }
                            
                            self.validTime = properties["validTime"] as! String
                            
                            if properties["top"] != nil {
                                
                                self.top = properties["top"] as! String
                                
                            }
                            
                            if properties["base"] != nil {
                                
                                self.base = properties["base"] as! String
                                
                            }
                            
                            if properties["severity"] != nil {
                                
                                self.severity = properties["severity"] as! String
                                
                            }
                            
                            if properties["fzlbase"] != nil {
                                
                                self.fzlbase = properties["fzlbase"] as! String
                                
                            }
                            
                            if properties["fzltop"] != nil {
                                
                                self.fzltop = properties["fzltop"] as! String
                                
                            }
                            
                            if properties["dueTo"] != nil {
                                
                                self.dueTo = properties["dueTo"] as! String
                                
                            }
                            
                            if let color = properties["color"]{
                                
                                let colorAsString : String = "\(color)"
                                
                                self.colorToFill = colorAsString
                                
                            }
                            
                            let type = feature["type"] as! NSString
                            
                            let coordinates = feature["coordinates"] as! NSArray
                            
                            var pointsToPlot:[CLLocationCoordinate2D] = []
                            
                            if type != "Point"{
                                
                                if type == "Polygon" {
                                    
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
                                    
                                }else {
                                    
                                    var points: [CLLocationCoordinate2D] = []
                                    
                                    for coordinate in coordinates {
                                        
                                        let latitude = coordinate[1] as! Double
                                        
                                        let longitude = coordinate[0] as! Double
                                        
                                        points.append(CLLocationCoordinate2DMake(latitude,longitude))
                                        
                                        let polyline = MKPolyline(coordinates: &points, count: points.count)
                                        
                                        self.mapView.addOverlay(polyline)
                                        
                                    }
                                    
                                }}
                                
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
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolygon {
            
            
            
            
            let polygonView = MKPolygonRenderer(overlay: overlay)
            
            //let color = colorToFill.hexaToDecimal
            
            if self.hazard == "ICE" {
                
                polygonView.strokeColor = UIColor.blueColor()
                
                polygonView.fillColor = UIColor.blueColor()
                
            } else if self.hazard == "M_FZLVL" {
                
                polygonView.strokeColor = UIColor.yellowColor()
                
                polygonView.fillColor = UIColor.blueColor()
                
            } else if self.hazard == "TURB-HI"{
                
                polygonView.strokeColor = UIColor.orangeColor()
                
                polygonView.fillColor = UIColor.orangeColor()
                
                
            } else if self.hazard == "TURB-LO" {
                
                polygonView.strokeColor = UIColor.redColor()
                polygonView.fillColor = UIColor.redColor()
                
            } else if self.hazard == "MT_OBSC" {
                // We should plot pink color here
                
                polygonView.strokeColor = UIColor.redColor()
                polygonView.fillColor = UIColor.redColor()
                
            } else if self.hazard == "IFR" {
                
                polygonView.strokeColor = UIColor.purpleColor()
                polygonView.fillColor = UIColor.purpleColor()
                
            } else if self.hazard == "LLWS" {
                
                polygonView.strokeColor = UIColor.brownColor()
                polygonView.fillColor = UIColor.brownColor()
                
            }
            polygonView.alpha = 0.5
            return polygonView
        }
            
        else{
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer()
            }
            
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 3.0
            renderer.alpha = 0.5
            renderer.strokeColor = UIColor.blueColor()
            
            return renderer
        }
    }
}




extension HazardsViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark:MKPlacemark){
        
        
        count += 1
        // cache the pin
        
        selectedPin = placemark
        
        // clear existing pins
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        if let city = placemark.locality,
            
            let state = placemark.administrativeArea {
            
            annotation.subtitle = "\(city) \(state) -- Destination"
            
            drawLines(annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            
        }
        
        mapView.addAnnotation(annotation)
        if count == 1{
            userSourceLocation = location
        }
        else if count == 2{
            userDestinationLocation = location
            checkForTafs(icaoID,userSourceLocation: userSourceLocation, userDestinationLocation: userDestinationLocation)
        }
        
        
        let span = MKCoordinateSpanMake(35, 35)
        
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        
        mapView.setRegion(region, animated: true)
        
        
        
        let alert:UIAlertController = UIAlertController(title: "Do you want to use this as your destination location?", message: "" , preferredStyle: .Alert)
        
        let defaultAction:UIAlertAction =  UIAlertAction(title: "Yes", style: .Default, handler: nil)
        
        alert.addAction(defaultAction)
        
        let noAction:UIAlertAction = UIAlertAction(title:"No", style: .Cancel, handler: nil)
        
        alert.addAction(noAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
}



extension Double {
    
    var roundedTwoDigits:Double {
        return Double(round(100*self/100))
    }
}


