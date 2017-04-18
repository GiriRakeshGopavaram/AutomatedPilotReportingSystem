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

class HazardsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    
    var appDelegate:AppDelegate!
    
    var selectedAnnotation:MKAnnotation!
    
    var tafResults:[NSDictionary]!
    
    var selectedAnnotationView:MKAnnotationView! = MKAnnotationView()
    
    var tafLocations:[CLLocationCoordinate2D]! = []
    
    var propertiesToDisplay:[String:AnyObject] = [:]

    
    @IBOutlet weak var mapView: MKMapView!
    
    var icaoID:String! = ""
    
    var validTimeTo:String = ""
    
    var cover:String =  ""
    
    var fltcat: String = ""
    
    var rawTAF: String = ""
    
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
    
    var tafsAlongRoute:[CLLocationCoordinate2D]! = []
    
    var nearestDistance:CLLocationDistance!
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        
        
        locationManager.requestLocation()
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        mapView.delegate = self
        
        mapView.mapType = MKMapType.Standard
        
        mapView.showsUserLocation = true
        
        
        
        locationSearchTable.handleMapSearchDelegate = self
        
        definesPresentationContext = true
        
        getRequest()
        makeRequest()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updated")
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Something gone wrong")
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.FullScreen
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    // 1. user enter region
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //showAlert("enter \(region.identifier)")
    }
    
    
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "Yes", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        let noAction:UIAlertAction = UIAlertAction(title:"No", style: .Cancel, handler: nil)
        alert.addAction(noAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
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
                    tafResults = results
                    dispatch_async(dispatch_get_main_queue(), {
                        var properties:[String:AnyObject] = [:]
                        var geometry:[String:AnyObject] = [:]
                        for eachObject in results{
                            geometry = eachObject["geometry"] as! [String:AnyObject]
                            properties = eachObject["properties"] as! [String:AnyObject]
                            var coordinates:[Double] = []
                            var latitude:Double
                            var longitude:Double
                            coordinates = geometry["coordinates"] as! [Double]
                            longitude = (coordinates[0])
                            latitude = (coordinates[1])
                            let location = CLLocationCoordinate2D(latitude: latitude, longitude:  longitude)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = location
                            annotation.title = "TAF"
                            annotation.subtitle = "Observed at \(latitude), \(longitude)"
                            self.tafLocations.append(location)
                            
                            
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
        mapView.addOverlay(geodesicPolyline)
        for count in 0 ..< geodesicPolyline.pointCount{
            if count != 10{
                let location:CLLocationCoordinate2D = MKCoordinateForMapPoint(geodesicPolyline.points()[count])
                let regionradius = CLLocationDistance(40233.6)
                let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: location.latitude,
                    longitude: location.longitude), radius: regionradius, identifier: icaoID )
                self.locationManager.startMonitoringForRegion(region)
                for location in tafLocations{
                    if region.containsCoordinate(location){
                        tafsAlongRoute.append(location)
                    }
                }
                self.locationManager.stopMonitoringForRegion(region)
            }
        }
        plotTafs(tafsAlongRoute)
    }
    
    func plotTafs(tafLocation:[CLLocationCoordinate2D]){
        
        for location in tafLocation{
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
            
        }
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
        catch{
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {

            let polygonView = MKPolygonRenderer(overlay: overlay)
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
            } else if self.hazard == "IFR"{
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
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        self.mapView.selectedAnnotations.append(view.annotation!)
        selectedAnnotation = view.annotation
        print(selectedAnnotation.coordinate)

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
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        self.mapView.deselectAnnotation(selectedAnnotation, animated: true)

    }

    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        //self.mapView.selectAnnotation(selectedAnnotation, animated: true)
    }
}




extension HazardsViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark:MKPlacemark){
        count += 1
        // cache the pin
        selectedPin = placemark
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state) -- Destination"
        }
        mapView.addAnnotation(annotation)
        if count == 1{
            userSourceLocation = location
            let span = MKCoordinateSpanMake(10, 10)
            
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            
            mapView.setRegion(region, animated: true)
        }
        else if count == 2{
            userDestinationLocation = location
            checkForTafs(icaoID,userSourceLocation: userSourceLocation, userDestinationLocation: userDestinationLocation)
            let span = MKCoordinateSpanMake(30, 30)
            
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            
            mapView.setRegion(region, animated: true)
        }
   
    }
    
}



extension Double {
    var roundedTwoDigits:Double {
        return Double(round(100*self/100))
    }
}


