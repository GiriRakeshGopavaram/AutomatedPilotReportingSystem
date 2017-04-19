//
//  SendPIREP.swift
//  AutomatedPIREP
//
//  Created by admin on 4/18/17.
//  Copyright © 2017 Gopavaram,Giri Rakesh. All rights reserved.
//

import Foundation
import Parse
import Bolts
class SendPIREP:PFObject {
    
    @NSManaged var pirep:String
    
    init(pirep:String) {
        super.init()
        self.pirep = pirep
    }
    
    override init() {
        super.init()
    }
    
}
extension SendPIREP : PFSubclassing {
    
    class func parseClassName() -> String {
        return "SendPIREP"
    }
}