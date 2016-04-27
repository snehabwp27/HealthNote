//
//  HNPatient.swift
//  HealthNote_V1.0
//
//  Created by Manish on 4/27/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit

class HNPatient: NSObject
{
    override init()
    {
        super.init()
    }
    var name                    : String!
    var age                     : String!
    var gender                  : String!
    var height                  : String!
    var weight                  : String!
    var allergies               : String!
    var medicalHistory          : String!
    var emailId                 : String!
    var address                 : String!
    var phoneNumber             : String!
    var profilePicData          : NSData!
}
