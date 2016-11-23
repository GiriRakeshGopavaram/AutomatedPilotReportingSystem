////
////  MyView.swift
////  AutomatedPIREP
////
////  Created by admin on 11/22/16.
////  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
////
//
//import UIKit
//@IBDesignable
//class MyView: UIView {
//    var instance = PIREPDataViewController()
//    var worldOfStrings:String!
//    var turbulenceCondition = ""
//    var icingCondition = ""
//    let pirepView = PirepViewController()
//    // Only override drawRect: if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        // Drawing code
//        //makeRequest()
//        
//        callMe()
//        let turbulenceString: NSString = "Hello"
//        
//        // set the text color to dark gray
//        let fieldColor: UIColor = UIColor.darkGrayColor()
//        
//        // set the font to Helvetica Neue 18
//        let fieldFont = UIFont(name: "Helvetica Neue", size: 15)
//        
//        // set the line spacing to 6
//        let paraStyle = NSMutableParagraphStyle()
//        paraStyle.lineSpacing = 6.0
//        
//        // set the Obliqueness to 0.1
//        let skew = 0.1
//        
//        let attributes: NSDictionary = [
//            NSForegroundColorAttributeName: fieldColor,
//            NSParagraphStyleAttributeName: paraStyle,
//            NSObliquenessAttributeName: skew,
//            NSFontAttributeName: fieldFont!
//        ]
//        
//        turbulenceString.drawInRect(CGRectMake(20.0, 20.0, 300.0, 48.0), withAttributes: attributes as? [String : AnyObject])
//        let icingString: NSString = "No problem"
//        icingString.drawInRect(CGRectMake(20.0, 80.0, 300.0, 48.0), withAttributes: attributes as? [String : AnyObject])
//    }
//    
//    func callMe(){
//        setNeedsDisplay()
//        dispatch_async(dispatch_get_main_queue(), {
//            print("Finally \(self.instance.icoaId)")
//        })
//    }
//    
//    
//    }
//    
//
