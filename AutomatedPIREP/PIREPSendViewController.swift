//
//  PIREPSendViewController.swift
//  AutomatedPIREP
//
//  Created by Pruthvi Parne on 10/29/16.
//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
//

import UIKit

class PIREPSendViewController: UIViewController {

    @IBOutlet weak var test: UITextField!

    @IBAction func getJSON(sender: AnyObject) {
        makeRequest()
    }
    
    override func loadView() {
        super.loadView()
        makeRequest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRequest()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func makeRequest() {
        let url = NSURL(string: "https://new.aviationweather.gov/gis/scripts/MetarJSON.php")
        
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
                    //if let properties = results[0] as? [String:AnyObject]{
                        //if let id = properties["geometry"] as? NSString{
                    dispatch_async(dispatch_get_main_queue(), {

                        let gotIt:[String:AnyObject] = results[0] as! [String : AnyObject]

                        //print(gotIt["properties"])
                        let properties:[String:AnyObject] = gotIt["properties"] as! [String:AnyObject]
                        let geometry:[String:AnyObject] = gotIt["geometry"] as! [String:AnyObject]
                        let coordinates:[Double] = geometry["coordinates"] as! [Double]

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

}
