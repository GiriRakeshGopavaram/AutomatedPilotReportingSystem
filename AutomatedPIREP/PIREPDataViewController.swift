//
//  PIREPDataViewController.swift
//  AutomatedPIREP
//
//  Created by admin on 11/22/16.
//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
//

import UIKit

class PIREPDataViewController: UIViewController {

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
    var temperature:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(PIREPDataViewController.update), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func update(){
        dispatch_async(dispatch_get_main_queue(), {
            self.icaoIdLBL.text = self.icaoId
            self.obsTimeLBL.text = self.obsTime
            self.airepTypeLBL.text = self.airepType
            self.aircraftTypeLBL.text = self.aircraftType
            self.windSpeedLBL.text = self.windSpeed
            self.windDirectionLBL.text = self.windDirection
            self.flightLevelLBL.text = self.flightLevel
            self.temperatureLBL.text = self.temperature
            self.rawObservationTV.text = self.rawObservation
        })
    }


}
