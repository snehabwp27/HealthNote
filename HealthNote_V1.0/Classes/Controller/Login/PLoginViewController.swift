//
//  PLoginViewController.swift
//  HealthNote
//
//  Created by MANISH_iOS on 07/03/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit

class PLoginViewController: UIViewController
{
    @IBOutlet var tf_EmailID: UITextField!
    @IBOutlet var tf_Password: UITextField!

    @IBOutlet var btn_Login: UIButton!
    @IBOutlet var btn_Register: UIButton!
    
    @IBOutlet var imgV_Social1Login: UIImageView!
    @IBOutlet var imgV_Social2Login: UIImageView!
    @IBOutlet var imgV_Social3Login: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        preUI()
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Functions
    func preUI()
    {

        designButtons()
    }
    func designButtons()
    {
        Singleton.sharedInstance.applyEffects(btn_Login)
        Singleton.sharedInstance.applyEffects(btn_Register)
    }

    //MARK:- parse Login
    func parseLogin()
    {
      if tf_Password.text?.characters.count < 3
      {
        Singleton.sharedInstance.hideLoader()
        Singleton.sharedInstance.showAlertWithText("Failed", text: "Check input fields" , target: self)
      }else
      {
        let isValidEmail = Singleton.sharedInstance.isEmailAddressValid(tf_EmailID.text!) as Bool
        
        
                if isValidEmail == true || isValidEmail == false// for testing purpose
                {
                    let obj = HNParseLogin()
                    obj.username = self.tf_EmailID.text
                    obj.password = self.tf_Password.text
                    HNParse.sharedInstance.parseSignInUserWithParameters(obj, withCompletionHandler:
                        { (success, responseDic) -> () in
                            

                            if success == true
                            {
                                HNParse.sharedInstance.parseGetPatientDetailsForCurrentUser({ (success, responseDic) -> () in
                                    Singleton.sharedInstance.hideLoader()

                                    if success == true
                                    {
                                        self.loginVCPushFunc()
                                    }else
                                    {
                                        //Show Alert Login Failed according to response message
                                        Singleton.sharedInstance.showAlertWithText("Failed", text: responseDic as! String , target: self)
                                    }
                                })
                            }else
                            {
                                //Show Alert Login Failed according to response message
                                Singleton.sharedInstance.hideLoader()

                                Singleton.sharedInstance.showAlertWithText("Failed", text: responseDic as! String , target: self)
                            }
                        })

                }else
                {
                  //Show Alert Invalid email
                    Singleton.sharedInstance.hideLoader()
                    Singleton.sharedInstance.showAlertWithText("Failed", text: "Invalid input username" , target: self)

                }
        }
    }
    
    //Push Login VC
    func loginVCPushFunc()
    {
        SingletonStoryboard.sharedInstance.dashboardPushFromSingleton(self) { (success) -> Void in
            
        }

    }
    //MARK:- Actions
    @IBAction func loginButtonPressed(sender: AnyObject)
    {
        Singleton.sharedInstance.showLoaderWithTitle("Signing in...")
        parseLogin()
    }
    @IBAction func registerButtonPressed(sender: AnyObject)
    {
        SingletonStoryboard.sharedInstance.registerPushFromSingleton(self) { (success) -> Void in
            
        }

    }

}
