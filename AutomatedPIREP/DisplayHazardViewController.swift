//
//  DisplayHazardViewController.swift
//  AutomatedPIREP
//
//  Created by admin on 4/12/17.
//  Copyright © 2017 Gopavaram,Giri Rakesh. All rights reserved.
//

import UIKit

class DisplayHazardViewController: UIViewController {

    var properties: [String:AnyObject] = [:]
    
    @IBOutlet weak var validTimeLBL: UILabel!
    
    @IBOutlet weak var severityLBL: UILabel!
    
    
    @IBOutlet weak var hazardLBL: UILabel!
    
    @IBOutlet weak var topLBL: UILabel!
    
    @IBOutlet weak var baseLBL: UILabel!
    
    
    @IBOutlet weak var fzlTopLBL: UILabel!
    
    
    @IBOutlet weak var fzlBaseLBL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //: Function to update the hazard view properties and display in a pop-over
    func update(){
        let validTime:String! = String(self.properties["validTime"])
        var top:String! = String(self.properties["top"])
        var base:String! = String(self.properties["base"])
        var fzlBase:String! = String(self.properties["fzlbase"])
        var fzlTop:String! = String(self.properties["fzltop"])
        let severity:String! = String(self.properties["severity"])
        let hazard:String! = String(self.properties["hazard"])
        
        validTimeLBL.text! = validTime
        severityLBL.text! = severity
        hazardLBL.text! = hazard
        if top!.containsString("nil"){
            top = "Unknown"
        }
        if base!.containsString("nil"){
            base = "Unknown"
        }
        if fzlBase!.containsString("nil"){
            fzlBase = "Unknown"
        }
        if fzlTop!.containsString("nil"){
            fzlTop = "unknown"
        }
    }
}
