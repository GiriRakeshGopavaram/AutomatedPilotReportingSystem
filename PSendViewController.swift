//
//  PSendViewController.swift
//  AutomatedPIREP
//
//  Created by admin on 4/12/17.
//  Copyright © 2017 Gopavaram,Giri Rakesh. All rights reserved.
//

import UIKit

class PSendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var clearRimeMixedInd = ""
    var finalMessage = ""
    
    @IBOutlet weak var encodedMessage: UILabel!
    
    var icingCondition = ""
    var turbCondition = ""
    var chopCondition = ""
    
    @IBOutlet weak var icingLight: UIButton!
    
    
    @IBAction func clear(sender: AnyObject) {
        clearRimeMixedInd = ""
        clearRimeMixedInd = "CLEAR"
        finalMessage+=clearRimeMixedInd
    }
    
    
    @IBAction func RIME(sender: AnyObject) {
        clearRimeMixedInd = ""
        clearRimeMixedInd = "RIME"
        finalMessage+=clearRimeMixedInd
    }
    
    
    @IBAction func MIXED(sender: AnyObject) {
        clearRimeMixedInd = ""
        clearRimeMixedInd = "MIXED"
        finalMessage+=clearRimeMixedInd
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func icingNeg(sender: AnyObject) {
        icingCondition = ""
        icingCondition += "IC NEG"
        finalMessage+=icingCondition
        encodedMessage.text = finalMessage    }
    
    @IBAction func icingTrace(sender: AnyObject) {
    
        icingCondition = ""
        icingCondition += "IC TRACE"
        encodedMessage.text = icingCondition + clearRimeMixedInd
    }
 
    
    @IBAction func icingLight(sender: AnyObject) {
        icingCondition = ""
        icingCondition += "IC LGT"
        encodedMessage.text = icingCondition + clearRimeMixedInd
    }
    

 
    
    
    @IBAction func icingLightModerate(sender: AnyObject) {
    
        icingCondition = ""
        icingCondition += "IC LGT-MOD"
        encodedMessage.text = icingCondition + clearRimeMixedInd
    }
    
    @IBAction func icingModerate(sender: AnyObject) {
        
        icingCondition = ""
        icingCondition += "IC MOD"
        encodedMessage.text = icingCondition + clearRimeMixedInd
    }
    
    
    @IBAction func icingModerateSevere(sender: AnyObject) {
        icingCondition = ""
        icingCondition += "IC MOD-SEV"
        encodedMessage.text = icingCondition + clearRimeMixedInd
        
    }
    
    
    @IBAction func icingSevere(sender: AnyObject) {
        icingCondition = ""
        icingCondition += "IC SEV"
        encodedMessage.text = icingCondition
    }
    
    
    @IBAction func turbNeg(sender: UIButton) {
        turbCondition = ""
        turbCondition = "TB NEG"
        encodedMessage.text = icingCondition + turbCondition
        
    }
    
    
    @IBAction func turbNegLight(sender: AnyObject) {
        turbCondition = ""
        turbCondition = "TB NEG-LGT"
        encodedMessage.text = icingCondition + turbCondition
        
    }
    
    @IBAction func turbLGT(sender: AnyObject) {
        turbCondition = ""
        turbCondition = "TB LGT"
        encodedMessage.text = icingCondition + turbCondition
    }
    
    
    @IBAction func turbLightModerate(sender: AnyObject) {
        turbCondition = ""
        turbCondition = "TB LGT-MOD"
        encodedMessage.text = icingCondition + turbCondition
        
    }
    
    
    @IBAction func turbModerate(sender: AnyObject) {
        turbCondition = ""
        turbCondition = "TB MOD"
        encodedMessage.text = icingCondition + turbCondition
    }
    
    
    @IBAction func turbModSev(sender: AnyObject) {
        turbCondition = ""
        turbCondition = "TB MOD-SEV"
        encodedMessage.text = icingCondition + turbCondition
    }
    
    @IBAction func turbSev(sender: AnyObject) {
        turbCondition = ""
        turbCondition = "TB SEV"
        encodedMessage.text = icingCondition + turbCondition

    }
    
    
    
    
    
    @IBAction func chopNEG(sender: AnyObject) {
        chopCondition = ""
        chopCondition = "TB CHOP NEG"
        encodedMessage.text = icingCondition + turbCondition + chopCondition
        
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
