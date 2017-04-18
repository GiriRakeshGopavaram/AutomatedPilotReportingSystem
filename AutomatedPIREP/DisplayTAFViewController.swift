//
//  DisplayTAFViewController.swift
//  AutomatedPIREP
//
//  Created by admin on 4/12/17.
//  Copyright © 2017 Gopavaram,Giri Rakesh. All rights reserved.
//

import UIKit

class DisplayTAFViewController: UIViewController {

    //: Below variables and outlets are used in this view controller
    @IBOutlet weak var icaoIdLBL: UILabel!
    @IBOutlet weak var validTimeToLBL: UILabel!
    @IBOutlet weak var fltCatLBL: UILabel!
    @IBOutlet weak var rawTafTV: UITextView!
    var properties:[String:AnyObject]! = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        //:Displays the TAF properties requested by the user in a pop-over
        update()
    }

    //: Function to update the TAF view properties and display in a pop-over
    func update(){
            let icoaID:String = self.properties["id"] as! String
            let validTimeTo = self.properties["validTimeTo"]
            let fltcat:String = self.properties["fltcat"] as! String
            let rawTAF:String = self.properties["rawTAF"] as! String
            self.icaoIdLBL.text = icoaID
            self.validTimeToLBL.text = validTimeTo as? String
            self.fltCatLBL.text = fltcat
            self.rawTafTV.text = rawTAF
    }
    
}
