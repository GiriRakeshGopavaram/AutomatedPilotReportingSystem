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
        
        //mapView.showsUserLocation = true
        
        
        
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
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            
            
        }
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("error:: \(error)")
        
    }
    
    func makeRequest(){
        print("In make request")
        
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
    
    
    
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolygon {
            
            print(self.hazard)
            
            
            
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
            
            return polygonView
            
        }
            
        else{
            
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.blueColor()
            
            renderer.lineWidth = 5.0
            
            
            
            return renderer
            
        }
        
        
        
        return nil
        
    }
    
    
    
}



extension String {
    
    var drop0xPrefix:          String { return hasPrefix("0x") ? String(characters.dropFirst(2)) : self }
    
    var drop0bPrefix:          String { return hasPrefix("0b") ? String(characters.dropFirst(2)) : self }
    
    var hexaToDecimal:            Int { return Int(drop0xPrefix, radix: 16) ?? 0 }
    
    var hexaToBinaryString:    String { return String(hexaToDecimal, radix: 2) }
    
    var decimalToHexaString:   String { return String(Int(self) ?? 0, radix: 16) }
    
    var decimalToBinaryString: String { return String(Int(self) ?? 0, radix: 2) }
    
    var binaryToDecimal:          Int { return Int(drop0bPrefix, radix: 2) ?? 0 }
    
    var binaryToHexaString:    String { return String(binaryToDecimal, radix: 16) }
    
}


extension Int {
    
    var toBinaryString: String { return String(self, radix: 2) }
    
    var toHexaString:   String { return String(self, radix: 16) }
    
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
            
        else if mapView.annotations.count > 2{
            
            print(mapView.annotations.count)
            
            for annotation in mapView.annotations{
                
                mapView.removeAnnotation(annotation)
                
            }
            
            mapView.removeAnnotations(mapView.annotations)
            
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
                    
                    annotation.subtitle = "\(city) \(state) -- Destination"
                    
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
    
}


