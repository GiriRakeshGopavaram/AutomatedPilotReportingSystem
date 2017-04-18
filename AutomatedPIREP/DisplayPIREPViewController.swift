//
//  PIREPDataViewController.swift
//  AutomatedPIREP
//
//  Created by admin on 11/22/16.
//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
//

import UIKit

class DisplayPIREPViewController: UIViewController {
    
    //: Below variables and outlets are used in this view controller
    @IBOutlet weak var icaoIdLBL: UILabel!
    @IBOutlet weak var obsTimeLBL: UILabel!
    @IBOutlet weak var airepTypeLBL: UILabel!
    @IBOutlet weak var aircraftTypeLBL: UILabel!
    @IBOutlet weak var windSpeedLBL: UILabel!
    @IBOutlet weak var windDirectionLBL: UILabel!
    @IBOutlet weak var flightLevelLBL: UILabel!
    @IBOutlet weak var rawObservationTV: UITextView!
    @IBOutlet weak var temperatureLBL: UILabel!
    
    var icaoId:String!
    var obsTime:String!
    var airepType:String!
    var aircraftType:String!
    var windSpeed:String!
    var windDirection:String!
    var flightLevel:String!
    var rawObservation:String!
    var properties:[String:AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //:Set timer to call the update function
        update()
        
    }
    //: Function to update the PIREP view properties and display in a pop-over
    func update(){
        
        let icaoID:String = self.properties["icaoId"] as! String
        let obsTimeLBL:String = self.properties["obsTime"] as! String
        let airepType:String = self.properties["airepType"] as! String
        let airCraftType:String = self.properties["acType"] as! String
        var windSpeed:String? = String(self.properties["wspd"])
        var windDirection:String? = String(self.properties["wdir"])
        let flightLevel:String! = self.properties["fltlvl"] as! String
        let rawObservation:String = properties["rawOb"] as! String
        if windSpeed!.containsString("nil"){
            windSpeed = "Unknown"
        }
        if windDirection!.containsString("nil"){
            windDirection = "Unknown"
        }

        self.icaoIdLBL.text = icaoID
        self.obsTimeLBL.text = obsTimeLBL
        self.airepTypeLBL.text = airepType
        self.aircraftTypeLBL.text = airCraftType
        self.windSpeedLBL.text! = "\(windSpeed!) knots"
        self.windDirectionLBL.text! = "\(windDirection!) degrees"
        self.flightLevelLBL.text! = "\(Int(flightLevel)! * 100) feet"
        self.rawObservationTV.text = rawObservation
        
    }
}
