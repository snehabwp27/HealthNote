//
//  GlobalVariables.swift
//  HealthNote_V1.0
//
//  Created by Manish on 4/27/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit

class GlobalVariables
{
    
    // These are the properties you can store in your singleton
    var patientDetails  : HNPatient!
    var userDetails     : HNUserRegistration = HNUserRegistration()

    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: GlobalVariables
    {
        struct Static
        {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
