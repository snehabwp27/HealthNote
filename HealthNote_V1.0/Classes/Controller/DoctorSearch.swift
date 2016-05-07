//
//  DoctorSearch.swift
//  HealthNote
//
//  Created by Sneha Pimpalkar on 4/29/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit
import SideMenu

class DoctorSearch: UIViewController {
    
    var menuDashBoard: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        preUI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func preUI()
    {
        addLeftBarButtonWithImage()
    }
    //MARK:- UINavigation
    func addLeftBarButtonWithImage()
    {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "menuDashboard"), forState: UIControlState.Normal)
        button.addTarget(self, action:"toggleWindow", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame=CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func toggleWindow()
    {
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true)
        {
            
        }
    }


}
