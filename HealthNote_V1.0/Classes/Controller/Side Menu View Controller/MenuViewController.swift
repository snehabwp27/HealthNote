//
//  MenuViewController.swift
//  HealthNote
//
//  Created by MANISH_iOS on 07/03/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit
import SideMenu

let kCellIdentifierMenuTable: String = "menuTableCellId"

class MenuViewController: UIViewController
{
    @IBOutlet var menuTable: UITableView!
    
    var menuTableContentArray : NSMutableArray =  NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        preUI()
        preDataPopulate()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Functions
    func preUI()
    {
        //titleImageToNavBar()
        self.navigationController?.navigationBarHidden = false
        navigationItem.title = "Health Notes"
        self.automaticallyAdjustsScrollViewInsets = false
        let nib: UINib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        menuTable.registerNib(nib, forCellReuseIdentifier: kCellIdentifierMenuTable)

    }
    func titleImageToNavBar()
    {
        let titleView = UIView(frame: CGRectMake(0, 0, 100, 40))
        let titleImageView = UIImageView(image: UIImage(named: "textLogo"))
        titleImageView.frame = CGRectMake(0, 0, titleView.frame.width, titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView

    }
    func preDataPopulate()
    {
        let imageNames  = getCellImageNames()
        let cellNames   = getCellNames()
        
        for name in cellNames
        {
            let menuModelObj = MenuTableModel()
            menuModelObj.lbl_TitleText      = name
            menuModelObj.img_Name           = imageNames[cellNames .indexOf(name)!]
            menuTableContentArray .addObject(menuModelObj)
        }
    }
    
    // Getting Cell Names
    func getCellNames() -> [String]
    {
        return ["Dashboard", "Doctor Search", "Reminders", "Appointments", "Edit Profile", "Logout"]
    }
    
    // Getting Cell Images
    func getCellImageNames() -> [String]
    {
        return ["myChartMenu", "seeADocMenu", "reminders", "socialNetowrking", "editProfile", "logout"]
    }
    // Did Select Table view item
    func pushVCForIndexPath(indexPath : NSIndexPath)
    {
        switch indexPath.row
        {
        case 0:
            let vc = SingletonStoryboard.sharedInstance.getMainStoryboad().instantiateViewControllerWithIdentifier("dashboardVCId")
            self.navigationController?.pushViewController(vc, animated: true)
            break //
            
        case 1:
            let vc = SingletonStoryboard.sharedInstance.getMainStoryboad().instantiateViewControllerWithIdentifier("doctorsearchVCId")
            self.navigationController?.pushViewController(vc, animated: true)
            break //
            
        case 2:
            let vc = SingletonStoryboard.sharedInstance.getMainStoryboad().instantiateViewControllerWithIdentifier("remindersVCId")
            self.navigationController?.pushViewController(vc, animated: true)
            break //
            
        case 3:
            let vc = SingletonStoryboard.sharedInstance.getMainStoryboad().instantiateViewControllerWithIdentifier("appointmentsVCId")
            self.navigationController?.pushViewController(vc, animated: true)
            break //
            
        case 4:
            let vc = SingletonStoryboard.sharedInstance.getMainStoryboad().instantiateViewControllerWithIdentifier("profileVCId")
            self.navigationController?.pushViewController(vc, animated: true)
            break //
            
        case 5:
            HNParse.sharedInstance.parseUserLogout({ (success, responseDic) -> () in
                if success == true
                {
                    self.pushToRootVC()

                }
            })
            break //logout
            
        default:
            
            break //
            
        }
    }
    
    //Dashboard view push
    func pushToDashboardVC()
    {
        SingletonStoryboard.sharedInstance.dashboardPushFromSingleton(self) { (success) -> Void in
            
        }
    }

    
    //Root view push
    func pushToRootVC()
    {
        SingletonStoryboard.sharedInstance.loginPushFromSingleton(self) { (success) -> Void in
            
        }
    }

    
    // MARK: Table View Data Source
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
            return Macros.ScreenSize.SCREEN_HEIGHT * 0.085
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell: MenuTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifierMenuTable, forIndexPath: indexPath) as! MenuTableViewCell
        
        let menuModelObj        = menuTableContentArray[indexPath.row] as! MenuTableModel
        cell.imgV.image         = UIImage(named: menuModelObj.img_Name)
        cell.lbl_Title.text     = menuModelObj.lbl_TitleText
        
        cell.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        cell.contentView.clipsToBounds = true
        cell.layoutSubviews()

        cell.backgroundColor = cell.contentView.backgroundColor
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        pushVCForIndexPath(indexPath)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return menuTableContentArray.count
    }
    

}
