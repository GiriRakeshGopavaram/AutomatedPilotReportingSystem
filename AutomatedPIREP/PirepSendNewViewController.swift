//
//  PirepSendNewViewController.swift
//  AutomatedPIREP
//
//  Created by Pruthvi Parne on 3/7/17.
//  Copyright © 2017 Gopavaram,Giri Rakesh. All rights reserved.
//

import Parse
import Bolts
import UIKit

class PirepSendNewViewController: UIViewController {
    
    @IBOutlet weak var PirepText: UILabel!
    @IBOutlet weak var IcingSegCont: UISegmentedControl!
    @IBOutlet weak var TurbulenceSegCont: UISegmentedControl!
    @IBOutlet weak var ChopSegCont: UISegmentedControl!
    
    @IBAction func IcingChanged(sender: AnyObject) {
        PirepText.text = (sender as! UISegmentedControl).titleForSegmentAtIndex((sender as! UISegmentedControl).selectedSegmentIndex);
    }
    @IBAction func TurbulenceChanged(sender: AnyObject) {
    }
    @IBAction func ChopChanged(sender: AnyObject) {
    }
    
    
    @IBAction func PirepSend(sender: AnyObject) {
        let pirep = PFObject(className:"PIREP")

        pirep["text"] = self.PirepText.text
        
        pirep.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("yahoo!")
                // The object has been saved.
            } else {
                print("Something went wrong here!")
                // There was a problem, check error.description
            }
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        PirepText.text = IcingSegCont.titleForSegmentAtIndex(IcingSegCont.selectedSegmentIndex);
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
