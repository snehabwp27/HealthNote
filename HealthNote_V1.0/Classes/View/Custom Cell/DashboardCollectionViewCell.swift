//
//  DashboardCollectionViewCell.swift
//  HealthNote
//
//  Created by MANISH_iOS on 08/03/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var baseView: UIView!
    @IBOutlet var imgV:     UIImageView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        preUIChanges()
    }
    
    //MARK:- Functions

    func preUIChanges()
    {
        self.layer.borderColor = UIColor.clearColor().CGColor
        baseView.layer.borderColor = UIColor.clearColor().CGColor
    }

}
