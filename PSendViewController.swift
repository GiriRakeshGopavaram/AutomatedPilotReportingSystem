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
        encodedMessage.hidden = true
        self.view.backgroundColor = UIColor.lightGrayColor()
        icTraceBTN.enabled = false
        icTraceLgtBTN.enabled = false
        icLgtBTN.enabled = false
        icLgtModBtn.enabled = false
        icModBtn.enabled = false
        icModSevBTN.enabled = false
        icSevBTN.enabled = false
        
        
        // Do any additional setup after loading the view.
    }
    var clearRimeMixedInd = ""
    var finalMessage = ""
    
    
    @IBOutlet weak var encodedMessage: UILabel!
    
    //Icing Button labels
    
    @IBOutlet weak var icNegBTN: UIButton!
    @IBOutlet weak var icTraceBTN: UIButton!
    @IBOutlet weak var icTraceLgtBTN: UIButton!
    @IBOutlet weak var icLgtBTN: UIButton!
    @IBOutlet weak var icLgtModBtn: UIButton!
    @IBOutlet weak var icModBtn: UIButton!
    @IBOutlet weak var icModSevBTN: UIButton!
    @IBOutlet weak var icSevBTN: UIButton!
    
    
    //TB buttons
    
    @IBOutlet weak var tbNegBTN: UIButton!
    @IBOutlet weak var tbNegLgtBTN: UIButton!
    @IBOutlet weak var tbLgtBTN: UIButton!
    @IBOutlet weak var tbLgtModBTN: UIButton!
    @IBOutlet weak var tbModBTN: UIButton!
    @IBOutlet weak var tbModSevBTN: UIButton!
    @IBOutlet weak var tbSevBTN: UIButton!
    
    //TB CHOP button lables
    
    @IBOutlet weak var chopNegBTN: UIButton!
    @IBOutlet weak var chopNegLgtBTN: UIButton!
    @IBOutlet weak var chopLgtBTN: UIButton!
    @IBOutlet weak var chopLgtModBTN: UIButton!
    @IBOutlet weak var chopModBTN: UIButton!
    @IBOutlet weak var chopModSevBTN: UIButton!
    @IBOutlet weak var chopSevBTN: UIButton!
    var icingCondition = ""
    var turbCondition = ""
    var chopCondition = ""
    var mtnWvCondition = ""
    
   
    
    
    @IBAction func clear(sender: AnyObject) {
        clearRimeMixedInd = ""
        clearRimeMixedInd = " CLEAR"
        icTraceBTN.enabled = true
        icTraceLgtBTN.enabled = true
        icLgtBTN.enabled = true
        icLgtModBtn.enabled = true
        icModBtn.enabled = true
        icModSevBTN.enabled = true
        icSevBTN.enabled = true
        formatEncodedMessage()
    }
    
    
    @IBAction func RIME(sender: AnyObject) {
        clearRimeMixedInd = ""
        clearRimeMixedInd = " RIME"
        icTraceBTN.enabled = true
        icTraceLgtBTN.enabled = true
        icLgtBTN.enabled = true
        icLgtModBtn.enabled = true
        icModBtn.enabled = true
        icModSevBTN.enabled = true
        icSevBTN.enabled = true
        formatEncodedMessage()
        
    }
    
    
    @IBAction func MIXED(sender: AnyObject) {
        clearRimeMixedInd = ""
        clearRimeMixedInd = " MIXED"
        icTraceBTN.enabled = true
        icTraceLgtBTN.enabled = true
        icLgtBTN.enabled = true
        icLgtModBtn.enabled = true
        icModBtn.enabled = true
        icModSevBTN.enabled = true
        icSevBTN.enabled = true
        formatEncodedMessage()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func icingNeg(sender: AnyObject) {
        icingCondition = ""
        icingCondition += ",IC NEG"
        formatEncodedMessage()
    }
    
    @IBAction func icingTrace(sender: AnyObject) {
        
        icingCondition = ""
        icingCondition += ",IC TRACE"
        formatEncodedMessage()
    }
    
    
    @IBAction func icingLight(sender: AnyObject) {
        icingCondition = ""
        icingCondition += ",IC LGT"
        formatEncodedMessage()
    }
    
    
    
    @IBAction func icTraceLgt(sender: AnyObject) {
        icingCondition = ""
        icingCondition += ",IC TRACE-LGT"
        formatEncodedMessage()
    }
    
    
    @IBAction func icingLightModerate(sender: AnyObject) {
        
        icingCondition = ""
        icingCondition += ",IC LGT-MOD"
        encodedMessage.text = icingCondition + clearRimeMixedInd
        formatEncodedMessage()
    }
    
    @IBAction func icingModerate(sender: AnyObject) {
        
        icingCondition = ""
        icingCondition += ",IC MOD"
        formatEncodedMessage()
    }
    
    
    @IBAction func icingModerateSevere(sender: AnyObject) {
        icingCondition = ""
        icingCondition += ",IC MOD-SEV"
        
        formatEncodedMessage()
    }
    
    
    @IBAction func icingSevere(sender: AnyObject) {
        icingCondition = ""
        icingCondition += ",IC SEV"
        
        formatEncodedMessage()
    }
    
    
    @IBAction func turbNeg(sender: UIButton) {
        turbCondition = ""
        chopCondition = ""
        turbCondition = ",TB NEG"
        
        //        chopNegBTN.enabled = false
        chopNegLgtBTN.enabled = false
        chopLgtBTN.enabled = false
        chopLgtModBTN.enabled = false
        chopModBTN.enabled = false
        chopModSevBTN.enabled = false
        chopSevBTN.enabled = false
        
        
        formatEncodedMessage()
    }
    
    
    @IBAction func turbNegLight(sender: AnyObject) {
        turbCondition = ""
        chopCondition = ""
        turbCondition = ",TB NEG-LGT"
        chopNegBTN.enabled = false
        chopNegLgtBTN.enabled = false
        chopLgtBTN.enabled = false
        chopLgtModBTN.enabled = false
        chopModBTN.enabled = false
        chopModSevBTN.enabled = false
        chopSevBTN.enabled = false
        formatEncodedMessage()
        
    }
    
    @IBAction func turbLGT(sender: AnyObject) {
        turbCondition = ""
        chopCondition = ""
        turbCondition = ",TB LGT"
        chopNegBTN.enabled = false
        chopNegLgtBTN.enabled = false
        chopLgtBTN.enabled = false
        chopLgtModBTN.enabled = false
        chopModBTN.enabled = false
        chopModSevBTN.enabled = false
        chopSevBTN.enabled = false
        formatEncodedMessage()
    }
    
    
    @IBAction func turbLightModerate(sender: AnyObject) {
        turbCondition = ""
        chopCondition = ""
        turbCondition = ",TB LGT-MOD"
        chopNegBTN.enabled = false
        chopNegLgtBTN.enabled = false
        chopLgtBTN.enabled = false
        chopLgtModBTN.enabled = false
        chopModBTN.enabled = false
        chopModSevBTN.enabled = false
        chopSevBTN.enabled = false
        formatEncodedMessage()
        
    }
    
    
    @IBAction func turbModerate(sender: AnyObject) {
        turbCondition = ""
        chopCondition = ""
        turbCondition = ",TB MOD"
        chopNegBTN.enabled = false
        chopNegLgtBTN.enabled = false
        chopLgtBTN.enabled = false
        chopLgtModBTN.enabled = false
        chopModBTN.enabled = false
        chopModSevBTN.enabled = false
        chopSevBTN.enabled = false
        formatEncodedMessage()
    }
    
    
    @IBAction func turbModSev(sender: AnyObject) {
        turbCondition = ""
        chopCondition = ""
        turbCondition = ",TB MOD-SEV"
        chopNegBTN.enabled = false
        chopNegLgtBTN.enabled = false
        chopLgtBTN.enabled = false
        chopLgtModBTN.enabled = false
        chopModBTN.enabled = false
        chopModSevBTN.enabled = false
        chopSevBTN.enabled = false
        formatEncodedMessage()
    }
    
    @IBAction func turbSev(sender: AnyObject) {
        turbCondition = ""
        chopCondition = ""
        turbCondition = ",TB SEV"
        chopNegBTN.enabled = false
        chopNegLgtBTN.enabled = false
        chopLgtBTN.enabled = false
        chopLgtModBTN.enabled = false
        chopModBTN.enabled = false
        chopModSevBTN.enabled = false
        chopSevBTN.enabled = false
        formatEncodedMessage()
        
    }
    
    @IBAction func chopNEG(sender: AnyObject) {
        chopCondition = ""
        turbCondition = ""
        chopCondition = ",TB NEG CHOP"
        tbNegBTN.enabled = false
        tbNegLgtBTN.enabled = false
        tbLgtBTN.enabled = false
        tbLgtModBTN.enabled = false
        tbModBTN.enabled = false
        tbModSevBTN.enabled = false
        tbSevBTN.enabled = false
        formatEncodedMessage()
    }
    
    
    
    @IBAction func chopNegLgt(sender: AnyObject) {
        chopCondition = ""
        turbCondition = ""
        chopCondition = ",TB NEG-LGT CHOP"
        tbNegBTN.enabled = false
        tbNegLgtBTN.enabled = false
        tbLgtBTN.enabled = false
        tbLgtModBTN.enabled = false
        tbModBTN.enabled = false
        tbModSevBTN.enabled = false
        tbSevBTN.enabled = false
        formatEncodedMessage()
    }
    
    @IBAction func chopLight(sender: AnyObject) {
        chopCondition = ""
        turbCondition = ""
        chopCondition = ",TB LGT CHOP"
        tbNegBTN.enabled = false
        tbNegLgtBTN.enabled = false
        tbLgtBTN.enabled = false
        tbLgtModBTN.enabled = false
        tbModBTN.enabled = false
        tbModSevBTN.enabled = false
        tbSevBTN.enabled = false
        formatEncodedMessage()
    }
    
    
    @IBAction func chopLgtMod(sender: AnyObject) {
        chopCondition = ""
        turbCondition = ""
        chopCondition = ",TB LGT-MOD CHOP"
        tbNegBTN.enabled = false
        tbNegLgtBTN.enabled = false
        tbLgtBTN.enabled = false
        tbLgtModBTN.enabled = false
        tbModBTN.enabled = false
        tbModSevBTN.enabled = false
        tbSevBTN.enabled = false
        formatEncodedMessage()
    }
    
    
    @IBAction func chopMod(sender: AnyObject) {
        chopCondition = ""
        turbCondition = ""
        chopCondition = ",TB MOD CHOP"
        tbNegBTN.enabled = false
        tbNegLgtBTN.enabled = false
        tbLgtBTN.enabled = false
        tbLgtModBTN.enabled = false
        tbModBTN.enabled = false
        tbModSevBTN.enabled = false
        tbSevBTN.enabled = false
        formatEncodedMessage()
    }
    
    
    
    
    @IBAction func chopModSev(sender: AnyObject) {
        chopCondition = ""
        turbCondition = ""
        chopCondition = ",TB MOD-SEV CHOP"
        tbNegBTN.enabled = false
        tbNegLgtBTN.enabled = false
        tbLgtBTN.enabled = false
        tbLgtModBTN.enabled = false
        tbModBTN.enabled = false
        tbModSevBTN.enabled = false
        tbSevBTN.enabled = false
        formatEncodedMessage()
    }
    
    
    
    
    @IBAction func chopSev(sender: AnyObject) {
        chopCondition = ""
        turbCondition = ""
        chopCondition = ",TB SEV CHOP"
        tbNegBTN.enabled = false
        tbNegLgtBTN.enabled = false
        tbLgtBTN.enabled = false
        tbLgtModBTN.enabled = false
        tbModBTN.enabled = false
        tbModSevBTN.enabled = false
        tbSevBTN.enabled = false
        formatEncodedMessage()
        
    }
    
    
    
    
    @IBAction func mtnWvNeg(sender: AnyObject) {
        mtnWvCondition = ""
        mtnWvCondition = ",RM NEG MTNWV"
        
        
        formatEncodedMessage()
    }
    
    
    
    @IBAction func mtnWvNegLgt(sender: AnyObject) {
        mtnWvCondition = ""
        mtnWvCondition = ",RM NEG-LGT MTNWV"
        
        
        formatEncodedMessage()
    }
    
    
    @IBAction func mtnWvmtnWvLgt(sender: AnyObject) {
        mtnWvCondition = ""
        mtnWvCondition = ",RM LGT MTNWV"
        
        
        formatEncodedMessage()
    }
    
    
    @IBAction func mtnWvLgtMod(sender: AnyObject) {
        mtnWvCondition = ""
        mtnWvCondition = ",RM LGT-MOD MTNWV"
        
        
        formatEncodedMessage()
    }
    
    @IBAction func mtnWvMod(sender: AnyObject) {
        mtnWvCondition = ""
        mtnWvCondition = ",RM MOD MTNWV"
        
        
        formatEncodedMessage()
    }
    
    
    @IBAction func mtnWvModSev(sender: AnyObject) {
        mtnWvCondition = ""
        mtnWvCondition = ",RM MOD-SEV MTNWV"
        
        formatEncodedMessage()
    }
    
    
    @IBAction func mtnWvSev(sender: AnyObject) {
        mtnWvCondition = ""
        mtnWvCondition = ",RM SEV MTNWV"
        
        
        formatEncodedMessage()
    }
    
    func formatEncodedMessage(){
        encodedMessage.hidden = false
        encodedMessage.text = icingCondition + clearRimeMixedInd
            + turbCondition + chopCondition + mtnWvCondition
        
        let conditions = encodedMessage.text!.characters.split{$0 == ","}.map(String.init)
        encodedMessage.text = "  "
        var finalMessage = "  "
        for condition in conditions {
            
            finalMessage +=  condition + "/"
            
        }
        finalMessage.removeAtIndex(finalMessage.endIndex.predecessor())
        encodedMessage.text = finalMessage
        
    }
    
    
    @IBAction func pirepSendBTN(sender: AnyObject) {
        
        let pirepString = SendPIREP(pirep: encodedMessage.text!)
        pirepString.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                self.displayAlertWithTitle("Success", message: "PIREP has been sent successfully")
                print("Successfully sent PIREP")
                self.encodedMessage.text = ""
                self.icTraceBTN.enabled = false
                self.icTraceLgtBTN.enabled = false
                self.icLgtBTN.enabled = false
                self.icLgtModBtn.enabled = false
                self.icModBtn.enabled = false
                self.icModSevBTN.enabled = false
                self.icSevBTN.enabled = false
                self.icingCondition = ""
                self.turbCondition = ""
                self.chopCondition = ""
                self.mtnWvCondition = ""
                self.clearRimeMixedInd = ""
                self.tbNegBTN.enabled = true
                self.tbNegLgtBTN.enabled = true
                self.tbLgtBTN.enabled = true
                self.tbLgtModBTN.enabled = true
                self.tbModBTN.enabled = true
                self.tbModSevBTN.enabled = true
                self.tbSevBTN.enabled = true
                self.chopNegBTN.enabled = true
                self.chopNegLgtBTN.enabled = true
                self.chopLgtBTN.enabled = true
                self.chopLgtModBTN.enabled = true
                self.chopModBTN.enabled = true
                self.chopModSevBTN.enabled = true
                self.chopSevBTN.enabled = true
            } else {
                
                if let error = error {
                    print("Something terrible happened. Something like \(error.localizedDescription)")
                }
            }
        })
    }
    @IBAction func PirepSendCancelBTN(sender: AnyObject) {
        encodedMessage.text = ""
        icTraceBTN.enabled = false
        icTraceLgtBTN.enabled = false
        icLgtBTN.enabled = false
        icLgtModBtn.enabled = false
        icModBtn.enabled = false
        icModSevBTN.enabled = false
        icSevBTN.enabled = false
        icingCondition = ""
        turbCondition = ""
        chopCondition = ""
        mtnWvCondition = ""
        clearRimeMixedInd = ""
        tbNegBTN.enabled = true
        tbNegLgtBTN.enabled = true
        tbLgtBTN.enabled = true
        tbLgtModBTN.enabled = true
        tbModBTN.enabled = true
        tbModSevBTN.enabled = true
        tbSevBTN.enabled = true
        chopNegBTN.enabled = true
        chopNegLgtBTN.enabled = true
        chopLgtBTN.enabled = true
        chopLgtModBTN.enabled = true
        chopModBTN.enabled = true
        chopModSevBTN.enabled = true
        chopSevBTN.enabled = true
    }
    
    // Pass in a String and it will be displayed in an alert view
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
        // alert.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
}
