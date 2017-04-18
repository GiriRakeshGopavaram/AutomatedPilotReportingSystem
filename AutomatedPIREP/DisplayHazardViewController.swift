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
    @IBOutlet weak var hazardLBL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        update()
        let validTime = self.properties["validTime"]
        let hazard  = self.properties["hazard"]
        let top = (self.properties["top"])
        let base = (self.properties["base"])
        let fzlBase = (self.properties["fzlbase"])
        let fzlTop = (self.properties["fzltop"])
        let severity = (self.properties["severity"])

        if !(validTime == nil){
            let validTimeLBL = UILabel(frame: CGRectMake(116, 66, 83, 21))
            validTimeLBL.text = "Valid"
            self.view.addSubview(validTimeLBL)
            
            let validTimeValueLBL = UILabel(frame: CGRectMake(211, 66, 83, 40))
            validTimeValueLBL.text = validTime! as? String
            self.view.addSubview(validTimeValueLBL)
        }
        if !(hazard == nil){
            let hazardLBL = UILabel(frame: CGRectMake(116, 109, 83, 21))
            hazardLBL.text = "Hazard"
            self.view.addSubview(hazardLBL)
            
            let hazardValueLBL = UILabel(frame: CGRectMake(211, 107, 83, 40))
            hazardValueLBL.text = hazard! as? String
            self.view.addSubview(hazardValueLBL)
        }
      
        if !(severity == nil){
           let severityLBL = UILabel(frame: CGRectMake(116, 148, 83, 21))
            severityLBL.text = "Severity"
            self.view.addSubview(severityLBL)
            
            let severityValueLBL = UILabel(frame: CGRectMake(286, 148, 83, 21))
            severityValueLBL.text = severity! as? String
            self.view.addSubview(severityValueLBL)
        }
        if !(top == nil){
            let topLBL = UILabel(frame: CGRectMake(116, 191, 83, 21))
            topLBL.text = "Top"
            self.view.addSubview(topLBL)
            
            let topValueLBL = UILabel(frame: CGRectMake(286, 191, 83, 21))
            topValueLBL.text = String(top!)
            self.view.addSubview(topValueLBL)
        }
        if !(base == nil){
            let baseLBL = UILabel(frame: CGRectMake(116, 232, 83, 21))
            baseLBL.text = "Base"
            self.view.addSubview(baseLBL)
            
            let baseValueLBL = UILabel(frame: CGRectMake(286, 232, 83, 21))
            baseValueLBL.text = String(base!)
            self.view.addSubview(baseValueLBL)
        }
        if !(fzlTop == nil){
            let fzlTopLBL = UILabel(frame: CGRectMake(116, 273, 83, 21))
            fzlTopLBL.text = "Freezing Level Top"
            self.view.addSubview(fzlTopLBL)
            
            let fzlTopValueLBL = UILabel(frame: CGRectMake(286, 273, 83, 21))
            fzlTopValueLBL.text = String(fzlTop!)
            self.view.addSubview(fzlTopValueLBL)
        }
        if !(fzlBase == nil){
            let fzlBaseLBL = UILabel(frame: CGRectMake(116, 314, 83, 21))
            fzlBaseLBL.text = "Freezing Level Base"
            self.view.addSubview(fzlBaseLBL)
            
            let fzlBaseValueLBL = UILabel(frame: CGRectMake(286, 314, 83, 21))
            fzlBaseValueLBL.text = String(fzlBase!)
            self.view.addSubview(fzlBaseValueLBL)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //: Function to update the hazard view properties and display in a pop-over
    func update(){
        let validTime:String! = String(self.properties["validTime"])
        let hazard:String! = String(self.properties["hazard"])
        
        validTimeLBL.text! = validTime
        hazardLBL.text! = hazard
  
    }
}
