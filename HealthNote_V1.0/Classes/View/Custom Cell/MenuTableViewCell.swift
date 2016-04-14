//
//  MenuTableViewCell.swift
//  HealthNote
//
//  Created by MANISH_iOS on 08/03/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet var baseView: UIView!
    
    @IBOutlet var lbl_Title: UILabel!
    
    @IBOutlet var imgV: UIImageView!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        //uiDesign()

    }

    //MARK:- Functions
    override func layoutSubviews() {
        uiDesign()

    }
    func uiDesign()
    {

//        self.layer.borderColor = UIColor.blackColor().CGColor
//        self.layer.borderWidth = 0.30
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
