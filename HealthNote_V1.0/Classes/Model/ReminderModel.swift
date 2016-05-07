//
//  ReminderModel.swift
//  HealthNote_V1.0
//
//  Created by Manish on 4/28/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit

class ReminderModel: NSObject
{
    override init()
    {
        super.init()
    }
    
    var startDateString : String!
    var endDateString : String!
    var medicine : String!
    var patient_email : String!
    var range : String!
    var timing : String!
    var startDate : NSDate!
    var endDate : NSDate!
    var isAddedToCalendar : Bool!
    var isDeletedFromCalendar : Bool!
    
}
