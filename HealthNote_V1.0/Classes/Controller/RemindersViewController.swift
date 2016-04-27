//
//  RemindersViewController.swift
//  HealthNote_V1.0
//
//  Created by Manish on 4/27/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit
import SideMenu


let kCellIdentifierReminderTable: String = "reminderTableCellId"

class RemindersViewController: UIViewController
{

    @IBOutlet var reminderTable: UITableView!
    
    var remiderTableContentArray : NSMutableArray =  NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        preUI()
        preDataFetch()
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
        navigationItem.title = "Reminders"
        self.automaticallyAdjustsScrollViewInsets = false
        let nib: UINib = UINib(nibName: "ReminderTableViewCell", bundle: nil)
        reminderTable.registerNib(nib, forCellReuseIdentifier: kCellIdentifierReminderTable)
        addLeftBarButtonWithImage()
        
    }
    
    func preDataFetch()
    {
        Singleton.sharedInstance.showLoaderWithTitle("Fetching Reminders")
        HNParse.sharedInstance.parseGetRemindersForCurrentUser { (success, responseDic) -> () in
            Singleton.sharedInstance.hideLoader()
            if success == true
            {
                for item in responseDic as! NSArray
                {
                    let model = ReminderModel()
                    if let a = item.valueForKey("StartDate")
                    {
                        model.startDateString = a as! String
                        model.startDate = Singleton.sharedInstance.getDateFromString(model.startDateString)
                    }
                    if let a = item.valueForKey("EndDate")
                    {
                        model.endDateString = a as! String
                        model.endDate = Singleton.sharedInstance.getDateFromString(model.endDateString)
                    }
                    if let a = item.valueForKey("medicine")
                    {
                        model.medicine = a as! String
                    }
                    if let a = item.valueForKey("patient_email")
                    {
                        model.patient_email = a as! String
                    }
                    if let a = item.valueForKey("range")
                    {
                        model.range = a as! String
                    }
                    if let a = item.valueForKey("timing")
                    {
                        model.timing = a as! String
                    }
                    if (NSUserDefaults.standardUserDefaults().valueForKey(self.getUniqueKeyFromModelReminder(model)) != nil)
                    {
                        model.isAddedToCalendar = true
                    }else
                    {
                        model.isAddedToCalendar = false
                    }
                    model.isDeletedFromCalendar = false
                    self.remiderTableContentArray .addObject(model)
                    
                }
                self.reminderTable .reloadData()
            }
        }
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
    //MARK:- Adding to calendar
    func addModelToCalendar(sender:UIButton)
    {
        let obj = remiderTableContentArray[sender.tag] as! ReminderModel

        if (NSUserDefaults.standardUserDefaults().valueForKey(getUniqueKeyFromModelReminder(obj)) != nil)
        {
            Singleton.sharedInstance.showAlertWithText("Already Addedd", text: "This is already added to calendar", target: self)
            return
        }
        Singleton.sharedInstance.saveEvent(obj.startDate, endDate: obj.endDate, title: obj.medicine, message: "\(obj.timing) - With range - \(obj.range)") { (success, response) -> () in
            if success == true
            {
                // Here save response Event Id to database to delete it from Calendar
                obj.isAddedToCalendar = true
                self.remiderTableContentArray .replaceObjectAtIndex(self.remiderTableContentArray .indexOfObject(obj), withObject: obj)
                
                NSUserDefaults.standardUserDefaults().setValue(response, forKey: self.getUniqueKeyFromModelReminder(obj))
                NSUserDefaults.standardUserDefaults().synchronize()
                
                self.reminderTable .reloadData()
            }
        }

    }
    func getUniqueKeyFromModelReminder(obj : ReminderModel) -> String
    {
        return "\(obj.medicine) -\(obj.startDateString) -\(obj.endDateString) -\(obj.range)"
    }
    // MARK: Table View Data Source
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return Macros.ScreenSize.SCREEN_HEIGHT * 0.285
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell: ReminderTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifierReminderTable, forIndexPath: indexPath) as! ReminderTableViewCell
        
        let obj = remiderTableContentArray[indexPath.row] as! ReminderModel
        cell.reminderButton.tag = indexPath.row
        cell.medicine.text = obj.medicine
        cell.startDate.text = obj.startDateString
        cell.endDate.text = obj.endDateString
        cell.timing.text = obj.timing
        if obj.isAddedToCalendar == false
        {
            cell.reminderButton .addTarget(self, action: "addModelToCalendar:", forControlEvents: .TouchUpInside)
        }else
        {
            cell.reminderButton.hidden = true
        }
        cell.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        cell.contentView.clipsToBounds = true
        cell.layoutSubviews()
        
        cell.backgroundColor = cell.contentView.backgroundColor
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return remiderTableContentArray.count
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
            let delete = UITableViewRowAction(style: .Destructive, title: "Delete")
                { (action, indexPath) in
                // delete item at indexPath
                    let obj = self.remiderTableContentArray[indexPath.row] as! ReminderModel
                    if obj.isAddedToCalendar == true
                    {
                        // Here Delete from Calendar
                    }else
                    {
                        Singleton.sharedInstance.showAlertWithText("Not added to calendar", text: "Cant delete from calendar untill you add it.", target: self)
                    }
                }
            delete.backgroundColor = UIColor.purpleColor()
            return [delete]
    }
}
