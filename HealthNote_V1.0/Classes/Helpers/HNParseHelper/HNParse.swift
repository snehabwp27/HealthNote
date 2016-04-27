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
                        withCompletionHandler(success: true, responseDic: "Succesfully loggef in")
                } else {
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
    
    //MARK:- Patients
    func parseGetPatientDetailsForCurrentUser(withCompletionHandler:(success : Bool, responseDic : AnyObject)->())
    {
        
        let user = PFUser.currentUser()
        let query = PFQuery(className: "Patient")
        query.whereKey("patientUser", equalTo: user!)
        
        query .findObjectsInBackgroundWithBlock { (object, error) -> Void in
            
            if error == nil
            {
                if object?.count > 0
                {
                    self.savePatientDetailsGlobalVariable(object![0])
                }
                 withCompletionHandler(success: true, responseDic: object!)
            }else
            {
                withCompletionHandler(success: false, responseDic:"")

            }
        }

    }
    func savePatientDetailsGlobalVariable(object : PFObject)
    {
        let model = HNPatient()
        model.name              =  object["name"] as! String
        model.age               =  object["age"] as! String
        model.gender            =  object["gender"] as! String
        model.height            =  object["height"] as! String
        model.weight            =  object["weight"] as! String
        model.allergies         =  object["allergies"] as! String
        model.medicalHistory    =  object["medicalHistory"] as! String
        model.emailId           =  object["emailId"] as! String
        model.address           =  object["address"] as! String
        model.phoneNumber       =  object["phoneNumber"] as! String
        model.profilePicData    =  object["profilePicData"] as! NSData
        GlobalVariables.sharedManager.patientDetails = model

    }
    func parseSavePatientDetailsForCurrentUser(model : HNPatient, withCompletionHandler:(success : Bool, responseDic : AnyObject)->())
    {
        HNParse.sharedInstance.parseGetPatientDetailsForCurrentUser({ (success, responseDic) -> () in
            if success == true && responseDic.isKindOfClass(PFObject)
            {
                let obj = responseDic as! PFObject
                self.startSavingWithModel(model, obj: obj, withCompletionHandler: { (success, responseDic) -> () in
                    if success == true
                    {
                        withCompletionHandler(success: true, responseDic: "Saved succesfully")
                        
                    }else
                    {
                        withCompletionHandler(success: false, responseDic: " ")
                    }

                })
            }else
            {
                let obj : PFObject = PFObject(className: "Patient")
                self.startSavingWithModel(model, obj: obj, withCompletionHandler: { (success, responseDic) -> () in
                    if success == true
                    {
                        withCompletionHandler(success: true, responseDic: "Saved succesfully")
                        
                    }else
                    {
                        withCompletionHandler(success: false, responseDic: " ")
                    }
                })
            }
        })
    }

    func startSavingWithModel(model : HNPatient, obj : PFObject, withCompletionHandler:(success : Bool, responseDic : AnyObject)->())
    {
        // First I am saving file to parse
        var fName : String = String()
        if let nameModel = model.phoneNumber
        {
            fName = nameModel
            fName = fName + ".jpeg"
        }
        let file = PFFile(name:fName, data:model.profilePicData)
        obj["name"] = model.name
        obj["age"] = model.age
        obj["gender"] = model.gender
        obj["height"] = model.height
        obj["weight"] = model.weight
        obj["allergies"] = model.allergies
        obj["medicalHistory"] = model.medicalHistory
        obj["emailId"]  = model.emailId
        obj["address"] = model.address
        obj["phoneNumber"] = model.phoneNumber
        obj["profilePicData"] = file
        obj["patientUser"] = PFUser.currentUser()
        
        obj.saveInBackgroundWithBlock({ (success, error) -> Void in
            
            if success == true && error == nil
            {
                withCompletionHandler(success: true, responseDic: "Saved succesfully")
                
            }else
            {
                withCompletionHandler(success: false, responseDic: " ")
            }
        })

    }
}
