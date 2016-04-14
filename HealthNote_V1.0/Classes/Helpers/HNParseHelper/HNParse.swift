//
//  HNParse.swift
//  HealthNote_V1.0
//
//  Created by Manish on 4/3/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit
import Parse

class HNParse: NSObject
{
    static let sharedInstance = HNParse()
    
    override init()
    {
        super.init()
    }
    
    //MARK:- Login
    func parseSignInUserWithParameters(LoginObj : HNParseLogin, withCompletionHandler:(success : Bool, responseDic : AnyObject)->())
    {

        PFUser.logInWithUsernameInBackground(LoginObj.username, password:LoginObj.password)
            {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil
                {
//                    if user!["emailVerified"] as! Bool == true
//                    {
                        // Do stuff after successful login.
                        withCompletionHandler(success: true, responseDic: "Succesfully loggef in")
//                    }
//                    else
//                    {
//                        withCompletionHandler(success: false, responseDic: "Email not verified")
//                    }
                } else {
                    // The login failed. Check error to see why.
                    withCompletionHandler(success: false, responseDic: "User not available")
                }
            }
    }
    
    func parseUserRegistrationWithParameters(signUpObj : HNUserRegistration, withCompletionHandler:(success : Bool, responseDic : AnyObject)->())
    {
        let user = PFUser()
        user.username       = signUpObj.username
        user.email          = signUpObj.email
        user.password       = signUpObj.password
        user["firstname"]   = signUpObj.firstName
        user["lastname"]    = signUpObj.lastName
        user["phoneNo"]     = signUpObj.phoneNumber
        user["city"]        = signUpObj.city
        user["gender"]      = signUpObj.gender
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                
                // Do stuff after successful login.
                withCompletionHandler(success: false, responseDic: "Failed - \(errorString)")

            } else {
                // Hooray! Let them use the app now.
                // Do stuff after successful login.
                withCompletionHandler(success: true, responseDic: "Registration success !")

            }
        }
    }
    
    //MARK:- Logout
    func parseUserLogout(withCompletionHandler:(success : Bool, responseDic : AnyObject)->())
    {

        PFUser.logOut()
        withCompletionHandler(success: true, responseDic: "")
        
    }
}
