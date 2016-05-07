//
//  Constant.swift
//  Lasso
//
//  Created by Manish on 08/01/16.
//  Copyright © 2016 QMC243-MAC-ShrikantP. All rights reserved.
//

import Foundation
import UIKit

struct Macros
{
    struct ScreenSize
    {
        static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    }

    struct URLs
    {
      static  let BASE_SERVER : String = NSBundle.mainBundle().objectForInfoDictionaryKey("BASE_SERVER") as! String
       static let BASE_SERVER_URL : String =  NSBundle.mainBundle().objectForInfoDictionaryKey("BASE_SERVER_URL") as! String
    }
    struct Colors
    {
        static let CELL_TAPPED_COLOR : UIColor = UIColor(colorLiteralRed: 153.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
    }

}
