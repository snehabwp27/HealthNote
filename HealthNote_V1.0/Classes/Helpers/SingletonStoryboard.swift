//
//  SingletonStoryboard.swift
//  HealthNote
//
//  Created by MANISH_iOS on 14/03/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit

class SingletonStoryboard: NSObject
{
    static let sharedInstance = SingletonStoryboard()
    
    override init()
    {
        super.init()
    }
    
    // Pushing Login VC
    func loginPushFromSingleton(target: UIViewController, withCompletionHAndler:(success : Bool) ->Void)
    {
        let vc = getMainStoryboad().instantiateViewControllerWithIdentifier("loginVCId")
        target.navigationController?.pushViewController(vc, animated: true)
        withCompletionHAndler(success: true)
    }
    // Pushing Register VC
    func registerPushFromSingleton(target: UIViewController, withCompletionHAndler:(success : Bool) ->Void)
    {
        let vc = getMainStoryboad().instantiateViewControllerWithIdentifier("registerVCId")
        target.navigationController?.pushViewController(vc, animated: true)
        withCompletionHAndler(success: true)
    }
    // Pushing Dashboard
    func dashboardPushFromSingleton(target: UIViewController, withCompletionHAndler:(success : Bool) ->Void)
    {
        let vc = getMainStoryboad().instantiateViewControllerWithIdentifier("dashboardVCId")
        target.navigationController?.pushViewController(vc, animated: true)
        withCompletionHAndler(success: true)
    }
    // Logout top vc
    func logoutPushFromSingleton(target: UIViewController, withCompletionHAndler:(success : Bool) ->Void)
    {
        target.navigationController?.popToRootViewControllerAnimated(true)
        withCompletionHAndler(success: true)
    }
    // Find A Doc Storyboard
    func getMainStoryboad() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    //Patient Storyboard
    func patientPushFromSingleton(target : UIViewController, withCompletionHandler:(success : Bool) ->Void)
    {
        let vc = getMainStoryboad().instantiateViewControllerWithIdentifier("patientVCId")
        target.navigationController?.pushViewController(vc, animated: true)
        withCompletionHandler(success: true)
    }

}
