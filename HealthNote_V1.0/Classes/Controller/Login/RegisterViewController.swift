//
//  RegisterViewController.swift
//  HealthNote_V1.0
//
//  Created by Manish on 3/26/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController
{
    
    @IBOutlet var btn_Register: UIButton!

    @IBOutlet var txtFirstname: UITextField!
    @IBOutlet var txtLastname: UITextField!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtRetypePassword: UITextField!
    @IBOutlet var txtPhoneNo: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtGender: UITextField!

    
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
        self.navigationController?.navigationBarHidden = false
       self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        navigationItem.title = "Join us..."
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func preUI()
    {
        Singleton.sharedInstance.applyEffects(btn_Register)
//        self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()

    }

    func checkBlankValidation() -> Bool
    {
        var allOk : Bool!
        if txtFirstname.text == ""
            || txtLastname.text == ""
            || txtUsername.text == ""
            || txtEmail.text == ""
            || txtPassword.text == ""
            || txtRetypePassword.text == ""
            || txtPhoneNo.text == ""
            || txtCity.text == ""
            || txtGender.text == ""
        {
            Singleton.sharedInstance.showAlertWithText("Registration Failed", text: "Please enter the details, All the fields are mandatory!" , target: self)
            
            allOk =  false

        }else
        {
            if txtPassword.text != txtRetypePassword.text// Checking both password is same or not., It can be done in text field delegate also.
            {
                Singleton.sharedInstance.showAlertWithText("Password mismatch", text: "Make sure you re-type password correctly!" , target: self)

                return false
            }else
            {
                let isValidEmail = Singleton.sharedInstance.isEmailAddressValid(txtEmail.text!) as Bool
                if isValidEmail == false
                {
                    Singleton.sharedInstance.showAlertWithText("Email incorrect", text: "Please check the entered email address." , target: self)
                    return false
                }else
                {
                    return true
                }
            }
        }
        
        return false
    }
    
    func registerParseWithUserObj(obj : HNUserRegistration)
    {
        HNParse.sharedInstance.parseUserRegistrationWithParameters(obj) { (success, responseDic) -> () in
            Singleton.sharedInstance.hideLoader()// Hide Activity Indicator
            if success == true
            {
                SingletonStoryboard.sharedInstance.dashboardPushFromSingleton(self) { (success) -> Void in
                    
                }

            }else
            {
                Singleton.sharedInstance.showAlertWithText("Registration Failed", text: "\(responseDic)" , target: self)
            }
        }
    }
    @IBAction func registerBtnPressed(sender: AnyObject)
    {
        Singleton.sharedInstance.showLoaderWithTitle("Registering...")
        if checkBlankValidation() == true
        {
            // Populating model object
            let obj =  HNUserRegistration()
            obj.firstName   = txtFirstname.text
            obj.lastName    = txtLastname.text
            obj.password    = txtPassword.text
            obj.username    = txtUsername.text
            obj.phoneNumber = txtPhoneNo.text
            obj.city        = txtCity.text
            obj.gender      = txtGender.text
            obj.email       = txtEmail.text

            registerParseWithUserObj(obj)
        }else
        {
            Singleton.sharedInstance.hideLoader()
        }
    }
}
