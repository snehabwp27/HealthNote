//
//  Singleton.swift
//  HealthNote
//
//  Created by MANISH_iOS on 14/03/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit
import SwiftLoader
import EventKit

class Singleton: NSObject
{
    static let sharedInstance = Singleton()
    let sharedApp  = UIApplication.sharedApplication()

    override init()
    {
        super.init()
    }
    
    //MARK:- Delay Function
    func delay(delay:Double, closure:()->())
    {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    //MARK:- User Interactions
    func disableViewUserInteraction(view : UIView)
    {
        view.userInteractionEnabled = false
    }
    func enableViewUserInteraction(view : UIView)
    {
        view.userInteractionEnabled = true
    }
    func disableWindowUserInteraction()
    {
        sharedApp .beginIgnoringInteractionEvents()
    }
    func enableWindowUserInteraction()
    {
        sharedApp .endIgnoringInteractionEvents()
    }
    //MARK:- Custom Loader
    func showLoaderWithTitle(title : String)
    {
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = .cyanColor()
        config.foregroundColor = .blackColor()
        config.foregroundAlpha = 0.4
        config.backgroundColor = .clearColor()
        config.titleTextColor = .whiteColor()
        SwiftLoader.setConfig(config)
        SwiftLoader.show(title: title, animated: true)

    }
    func hideLoader()
    {
        SwiftLoader.hide()

    }
    //MARK:- Alert
    func showAlertWithText(title: String, text: String, target : UIViewController)
    {
        //simple alert dialog
        let alert=UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.Alert);
        // Add Action
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil));
        //show it
        target.presentViewController(alert, animated: true, completion: { () -> Void in
            
        })
        
    }
    //MARK:- User Interface
    func applyEffects(btn : UIButton)
    {
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.clearColor()
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).CGColor
        btn.layer.cornerRadius = cornerRadius
    }
    func applyEffectsWithColor(btn : UIView, titleColor : UIColor, backgroundColor : UIColor)
    {
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        if btn .isKindOfClass(UIButton)
        {
            (btn as! UIButton).setTitleColor(titleColor, forState: UIControlState.Normal)
        }
        btn.backgroundColor = backgroundColor
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).CGColor
        btn.layer.cornerRadius = cornerRadius
    }
    
    func applyEffectToUIView(yourView : UIView)
    {
        yourView.layer.shadowColor = UIColor.whiteColor().CGColor
        yourView.layer.shadowOpacity = 1
        yourView.layer.shadowOffset = CGSizeZero
        yourView.layer.shadowRadius = 2
    }

    //MARK: - Email address validations.
    func isEmailAddressValid(testStr:String) -> Bool
    {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }

    
    
    //MARK:- NSDate
    func getDateFromString(str : String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.dateFromString( str )!
    }
    
    
    //EKEvent
    func saveEvent(statDate : NSDate, endDate : NSDate, title : String, message : String, withCompletionHandler:(success : Bool, response : String)->())
    {
        // 1
        let eventStore = EKEventStore()
        
        // 2
        switch EKEventStore.authorizationStatusForEntityType(.Event) {
        case .Authorized:
            self.insertEvent(eventStore, statDate: statDate, endDate: endDate, title: title, message: message, withCompletionHandler: { (success, response) -> () in
                if success == true
                {
                    withCompletionHandler(success: true, response: response)
                }else
                {
                    withCompletionHandler(success: false, response: response)
                }
                
            })
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            // 3
            eventStore.requestAccessToEntityType(.Event, completion: { (success, error) -> Void in
                if success && error == nil
                {
                    self.insertEvent(eventStore, statDate: statDate, endDate: endDate, title: title, message: message, withCompletionHandler: { (success, response) -> () in
                        
                        if success == true
                        {
                            withCompletionHandler(success: true, response: response)
                        }else
                        {
                            withCompletionHandler(success: false, response: response)
                        }
                    })
                    
                }
            })        default:
                print("Case Default")
        }
        
    }
    func insertEvent(store: EKEventStore,statDate : NSDate, endDate : NSDate, title : String, message : String, withCompletionHandler:(success : Bool, response : String)->())
    {
        // 1
        
        // Create Event
        let event = EKEvent(eventStore: store)
        event.calendar = store.defaultCalendarForNewEvents
        
        event.title = title
        event.notes = message
        event.startDate = statDate
        event.endDate = endDate
        event.addAlarm(EKAlarm(relativeOffset: -5.0))
        
        // Save Event in Calendar
        do
        {
            try store.saveEvent(event, span: .ThisEvent)
            print(event.eventIdentifier)
            withCompletionHandler(success: true, response: event.eventIdentifier)
            
        }catch
        {
            withCompletionHandler(success: false, response: "")
            
        }
        
    }


}
