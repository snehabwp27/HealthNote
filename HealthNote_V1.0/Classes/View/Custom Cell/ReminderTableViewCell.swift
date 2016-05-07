//
//  ReminderTableViewCell.swift
//  HealthNote_V1.0
//
//  Created by Manish on 4/28/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell
{
    @IBOutlet var baseView: UIView!

    @IBOutlet var medicine: UILabel!
    
    @IBOutlet var startDate: UILabel!
    
    @IBOutlet var endDate: UILabel!
    
    
    @IBOutlet var timing: UILabel!
    
    @IBOutlet var reminderButton: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        baseView.backgroundColor = UIColor.clearColor()
        Singleton.sharedInstance.applyEffectsWithColor(reminderButton, titleColor: UIColor.blackColor(), backgroundColor: UIColor.grayColor())
//        Singleton.sharedInstance.applyEffectToUIView(baseView)
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
