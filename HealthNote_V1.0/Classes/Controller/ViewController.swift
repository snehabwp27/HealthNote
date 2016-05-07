//
//  ViewController.swift
//  HealthNote
//
//  Created by MANISH_iOS on 07/03/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit
import SideMenu
import WatchKit
import WatchConnectivity
import Foundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, WCSessionDelegate, SChartDatasource, SChartDelegate {
    
    let licenseKey = "n4dJjTxXsUkcchPMjAxNjA1MjJwb29qYS5zaHVrbGFAc2pzdS5lZHU=EYS1Fmr4CcZuNLU1Nywgw8GOxq9VEXvp+ACoxhevhSZ45Cl5Kj+fe1VR1e5paN50LAe7m726Q1QLU4bmqJCBQ/zhP873ukHC2ZuKu/k8JGCWFT6qJAH24W0L/2xdPxiCz3METIcPuydJNlAKe8TIv9DbSlD0=AXR/y+mxbZFM+Bz4HYAHkrZ/ekxdI/4Aa6DClSrE4o73czce7pcia/eHXffSfX9gssIRwBWEPX9e+kKts4mY6zZWsReM+aaVF0BL6G9Vj2249wYEThll6JQdqaKda41AwAbZXwcssavcgnaHc3rxWNBjJDOk6Cd78fr/LwdW8q7gmlj4risUXPJV0h7d21jO1gzaaFCPlp5G8l05UUe2qe7rKbarpjoddMoXrpErC9j8Lm5Oj7XKbmciqAKap+71+9DGNE2sBC+sY4V/arvEthfhk52vzLe3kmSOsvg5q+DQG/W9WbgZTmlMdWHY2B2nbgm3yZB7jFCiXH/KfzyE1A==PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+"
    
    var session: WCSession!
    var counterData = [String]()
    
    @IBOutlet weak var viewPieChart1: ShinobiChart!
    @IBOutlet weak var lblHeart: UILabel!
    
    var chartDictionary: [NSDate : Int] = [:]
    var JSONDictionary : [String:AnyObject] = NSDictionary() as! [String : AnyObject]
    var xAxisArray : [String] = []
    var yAxisArray : [AnyObject] = []
    
    //share button - post data to server
    @IBAction func btnShareHeartData(sender: AnyObject) {
        print("Share button clicked")
        self.postHeartDataToServer()
    }
    
    @IBOutlet var menuDashBoard: UIBarButtonItem!
    var collectionContentArray : NSMutableArray =  NSMutableArray()
    var cellFrame : CGRect = CGRectZero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preUI()
        
        if isSideMenuAvailable == false
        {
            makeSideMenu()
            isSideMenuAvailable = true
        }
        
        preSetUp()
        
        if(WCSession.isSupported()){
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
            shinobiCharts()
            
        }
        
        //self.lblHeart.reloadInputViews()
    }
    
    // MARK: Heart rate capture session
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler _: ([String : AnyObject]) -> Void){
        //self.lblHeart.text = message["heartrate"] as? String
        print(" Heart Rate from iPhone ---> ", message["heartrate"] as? String)
        
        dispatch_async(dispatch_get_main_queue()){
            self.lblHeart.text = message["heartrate"] as? String
            //self.lblHeart.reloadInputViews()
            
            UIView.animateWithDuration(0.7, delay: 0.0,
                                       usingSpringWithDamping: 0.25,
                                       initialSpringVelocity: 0.0,
                                       options: [],
                                       animations: {
                                        //                                    cell!.layer.position.x += 200.0
                                        self.lblHeart!.center.x = self.view.center.x
                                        self.lblHeart!.layer.cornerRadius = 5.0
                                        self.lblHeart!.layer.borderWidth = 2.0
                                        self.lblHeart!.layer.borderColor = UIColor.redColor().CGColor
                                        self.lblHeart!.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1.0)
                }, completion: nil )
            
            
            let heartData = message["heartrate"] as! String
            
            if(heartData > "90" || heartData < "40"){
            Singleton.sharedInstance.showAlertWithText("Heart Rate Alert", text: "Hold On! Your pulse rate is \(heartData)" , target: self)
            }
            let date = NSDate()
            self.chartDictionary[date] = Int(heartData)
            
            
            self.viewPieChart1.reloadData()
            self.viewPieChart1.redrawChart()
            print(self.chartDictionary)
            
            self.JSONDictionary[String(date)]  = message["heartrate"]! as AnyObject
            
            self.xAxisArray.append(String(date))
            self.yAxisArray.append(message["heartrate"]! as AnyObject)
            
            
//           self.postHeartDataToServer()
            
            
        }
        
    }
    
    // MARK: plotly call
    func postHeartDataToServer() {
        
        let parameters = [
            "x": self.xAxisArray,
            "y": self.yAxisArray
        ]
        
        Alamofire.request(.POST, "https://health-note-sneha-pimpalkar.c9users.io/updateHeartRate", parameters: parameters, encoding: .JSON)
    }
    
    //Shinobi Charts
    func shinobiCharts(){
        //Shinobi Charts
        //        let margin = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? CGFloat(10) : CGFloat(50)
        //        let chart = ShinobiChart(frame: CGRectInset(view.bounds, margin, margin))
        viewPieChart1.title = "Heart Dashboard"
        viewPieChart1.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        viewPieChart1.licenseKey = licenseKey
        
        viewPieChart1.datasource = self
        viewPieChart1.delegate = self
        
        // add a pair of axes
        let xAxis = SChartDateTimeAxis()
        xAxis.title = "Time"
        xAxis.style.interSeriesPadding = 1.0
        viewPieChart1.xAxis = xAxis
        
        let yAxis = SChartNumberAxis()
        yAxis.title = "Heart Rate"
        yAxis.rangePaddingHigh = 1.0
        yAxis.rangePaddingLow = 1.0
        viewPieChart1.yAxis = yAxis
        
        
        xAxis.enableGesturePanning = true
        xAxis.enableGestureZooming = true
        yAxis.enableGesturePanning = true
        yAxis.enableGestureZooming = true
        
        viewPieChart1.legend.hidden = UIDevice.currentDevice().userInterfaceIdiom == .Phone
        
        //        view.addSubview(chart)
        
    }
    
    func numberOfSeriesInSChart(chart: ShinobiChart) -> Int {
        return 1
    }
    
    func sChart(chart: ShinobiChart, seriesAtIndex index: Int) -> SChartSeries {
        let lineSeries = SChartColumnSeries()
        
        if index == 0 {
            lineSeries.title = "HeartRate"
        } else {
            lineSeries.title = "Time"
        }
        
        lineSeries.style().showArea = true
        lineSeries.style().areaColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        //lineSeries.style().areaColorGradientBelowBaseline = UIColor.blueColor().colorWithAlphaComponent(0.8)
        return lineSeries
    }
    
    func sChart(chart: ShinobiChart, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return chartDictionary.count
    }
    
    
    func sChart(chart: ShinobiChart, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData {
        let datapoint = SChartDataPoint()
        
        //both functions share the same x-values
        let xValue = Array(chartDictionary.keys)[dataIndex]
        datapoint.xValue = xValue
        
        // compute the y-value for each series
        datapoint.yValue = chartDictionary[xValue]
        
        
        
        return datapoint
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Functions
    func preUI()
    {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBarHidden = false
        
        menuDashBoard.image = UIImage(named: "menuDashboard")!.imageWithRenderingMode(.AlwaysOriginal)
        
        // CollectionView
        //        dashboardCollectionView.dataSource = self
        //        dashboardCollectionView.delegate = self
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:1,left:10,bottom:10,right:10)
        layout.minimumInteritemSpacing = 5
        let heightScreen = Macros.ScreenSize.SCREEN_HEIGHT
        layout.minimumLineSpacing = heightScreen * 0.10 // Spacing in each cell from bottom in the collection view
        //        dashboardCollectionView.collectionViewLayout = layout
    }
    
    func preSetUp()
    {
        //        dashboardCollectionView!.registerNib(UINib(nibName: "DashboardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifierDashboardCollV)
        collectionContentArray.setArray(getCellImageNames())
        
    }
    
    func makeSideMenu()
    {
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewControllerWithIdentifier("LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .MenuSlideIn
        SideMenuManager.menuShadowOpacity = 1.0
        SideMenuManager.menuShadowRadius = 10.0
        
    }
    
    // Getting Cell Images
    func getCellImageNames() -> [String]
    {
        return []
    }
    
    //MARK:- Actions
    @IBAction func toggleWindow(sender: AnyObject)
    {
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true)
        {
            
        }
        
    }
    
//    // Did Select Collection view item
//    func pushVCForIndexPath(indexPath : NSIndexPath)
//    {
//        switch indexPath.row
//        {
//        case 0:
//            
//            break //
//            
//        case 1:
//            pushToDoctorSearchVC()
//            break //
//            
//        case 2:
//            pushToRemindersVC()
//            break //
//            
//        case 3:
//            pushToAppointmentsVC()
//            break
//            
//        case 4:
//            pushToProfileVC()
//            
//        case 5:
//            pushToRootVC()
//            break //logout
//            
//        default:
//            
//            break //
//            
//        }
//    }
    //Root view push
    func pushToRootVC()
    {
        SingletonStoryboard.sharedInstance.loginPushFromSingleton(self) { (success) -> Void in
            
        }
    }
    
    //Root view push
    func pushToDoctorSearchVC()
    {
        SingletonStoryboard.sharedInstance.doctorsearchPushFromSingleton(self) { (success) -> Void in
            
        }
    }
    //Root view push
    func pushToRemindersVC()
    {
        SingletonStoryboard.sharedInstance.remindersPushFromSingleton(self) { (success) -> Void in
            
        }
    }
    
    //Root view push
    func pushToAppointmentsVC()
    {
        SingletonStoryboard.sharedInstance.appointmentsPushFromSingleton(self) { (success) -> Void in
            
        }
    }
    
    //Root view push
    func pushToProfileVC()
    {
        SingletonStoryboard.sharedInstance.profilePushFromSingleton(self) { (success) -> Void in
            
        }
    }
    
}




























