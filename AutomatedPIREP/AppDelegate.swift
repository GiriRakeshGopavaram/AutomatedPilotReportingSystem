//
//  AppDelegate.swift
//  AutomatedPIREP
//
//  Created by Gopavaram,Giri Rakesh on 10/19/16.
//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
//

import UIKit
import Parse
import Bolts


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var airportLocations: Array<CLLocation> = []
    //    var sharedApplication = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //        Parse.setApplicationId("DTftczBeBsMpooTpjmG7zmFdo7pNCkfRfoaUmh1Y", clientKey: "uqrteJVH59pCnQYwErN1rXL90o8jlX36kOXSzk9E")
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "DTftczBeBsMpooTpjmG7zmFdo7pNCkfRfoaUmh1Y"
            $0.clientKey = "uqrteJVH59pCnQYwErN1rXL90o8jlX36kOXSzk9E"
            $0.server = "https://parseapi.back4app.com/"
        }
        
        Parse.initializeWithConfiguration(configuration)
        
        self.makeAnotherRequest()
        //makeRequest()
        
        return true
    }
    
//    func makeRequest() {
//        
//        let url = NSURL(string: "http://aviationweather.gov/gis/scripts/AirportJSON.php")
//        
//        // send out the request
//        
//        let session = NSURLSession.sharedSession()
//        
//        // implement completion handler
//        
//        session.dataTaskWithURL(url!, completionHandler: getResults).resume()
//        
//    }
//    
//    func getResults(data:NSData?,response:NSURLResponse?,error:NSError?)->Void{
//        do{
//            var jsonResult:NSDictionary?
//            try jsonResult =  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
//            if jsonResult != nil{
//                if let results = jsonResult!["features"] as? [NSDictionary]{
//                    dispatch_async(dispatch_get_main_queue(), {
//                        for eachObject in results{
//                            print(eachObject)
//                        }
//                        
//                    })
//                }
//                
//            }
//            
//        }
//        catch{
//            print("Sorry")
//        }
//    }
    
    func distanceBetweenTwoLocations(source:CLLocation,destination:CLLocation) -> Double{
        
        let distanceMeters = source.distanceFromLocation(destination)
        let distanceKM = distanceMeters / 1000
        let roundedTwoDigit = distanceKM.roundedTwoDigits
        
        return roundedTwoDigit
        
    }
    
    func nearestAirports(source:CLLocation, destination:CLLocation) -> Array<CLLocation> {
        
        print("Number of nearest airports \(self.airportLocations.count)")
        
        if self.airportLocations.count > 0 {
            self.airportLocations.sortInPlace({ distanceBetweenTwoLocations($0,destination:source) < distanceBetweenTwoLocations($1, destination: source) })
            
            return airportLocations[0...3] + []
        } else {
            return []
        }
    }
    
    func makeAnotherRequest(){
        
        let url = NSURL(string: "http://aviationweather.gov/gis/scripts/AirportJSON.php")
        
        // send out the request
        
        let session = NSURLSession.sharedSession()
        
        // implement completion handler
        
        session.dataTaskWithURL(url!, completionHandler: getResults).resume()
        
        
        
    }
    
    func getResults(data:NSData?,response:NSURLResponse?,error:NSError?)->Void{
        do{
            var jsonResult:NSDictionary?
            try jsonResult =  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            if jsonResult != nil{
                if let results = jsonResult!["features"] as? [NSDictionary]{
                    dispatch_async(dispatch_get_main_queue(), {
                        for eachObject in results{
                            let properties:[String:AnyObject] = eachObject["properties"] as! [String:AnyObject]
                            let region = properties["region"] as! String
                            if region == "US"{
                                let geometry = eachObject["geometry"] as! [String:AnyObject]
                                let coordinates = geometry["coordinates"] as! [Double]
                                let airportLocation = CLLocation(latitude: coordinates[1], longitude: coordinates[0])
                                
                                self.airportLocations.append(airportLocation)
                            }
                        }
                        
                    })
                }
                
            }
            
        }
        catch{
            print("Sorry")
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

