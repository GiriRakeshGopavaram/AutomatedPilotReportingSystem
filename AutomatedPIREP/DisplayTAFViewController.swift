//
//  DisplayTAFViewController.swift
//  AutomatedPIREP
//
//  Created by admin on 4/12/17.
//  Copyright © 2017 Gopavaram,Giri Rakesh. All rights reserved.
//

import UIKit

class DisplayTAFViewController: UIViewController {
    
    @IBOutlet weak var icaoIdLBL: UILabel!
    
    @IBOutlet weak var validTimeToLBL: UILabel!
    
    @IBOutlet weak var fltCatLBL: UILabel!
    
    @IBOutlet weak var rawTafTV: UITextView!
    var properties:[String:AnyObject]! = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(DisplayPIREPViewController.update), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    func update(){
        dispatch_async(dispatch_get_main_queue(), {
            let icoaID:String = self.properties["id"] as! String
            let validTimeTo = self.properties["validTimeTo"]
            let fltcat:String = self.properties["fltcat"] as! String
            let rawTAF:String = self.properties["rawTAF"] as! String
            self.icaoIdLBL.text = icoaID
            self.validTimeToLBL.text = validTimeTo as? String
            self.fltCatLBL.text = fltcat
            self.rawTafTV.text = rawTAF
            
        })
    }
    
}
