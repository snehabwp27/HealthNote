//
//  GetStartedVC.swift
//  HealthNote_V1.0
//
//  Created by Manish on 3/26/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit

class GetStartedVC: UIViewController {

    @IBOutlet var tv_Welcome: UITextView!
    
    @IBOutlet var btn_GetStarted: UIButton!
    
    override func viewDidLoad() {
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

        Singleton.sharedInstance.applyEffects(btn_GetStarted) // This is to apply white border to button

    }
    //MARK:- Actions
    
    @IBAction func getStartedPressed(sender: AnyObject)
    {
        SingletonStoryboard.sharedInstance.loginPushFromSingleton(self) { (success) -> Void in
            
        }
        
//        SingletonStoryboard.sharedInstance.dashboardPushFromSingleton(self) { (success) -> Void in
//            
//        }
    }
}
