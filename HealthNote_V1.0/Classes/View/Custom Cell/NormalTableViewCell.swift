//
//  NormalTableViewCell.swift
//  Temp
//
//  Created by MANISH_iOS on 26/04/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit

class NormalTableViewCell: UITableViewCell
{

    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var detailValLbl: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
