//
//  ViewController.swift
//  HealthNote
//
//  Created by MANISH_iOS on 07/03/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit
import SideMenu


let kCellIdentifierDashboardCollV: String = "menuTableCellId"


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource

{
    
    @IBOutlet var menuDashBoard: UIBarButtonItem!
    
    @IBOutlet var dashboardCollectionView: UICollectionView!
    
    var collectionContentArray : NSMutableArray =  NSMutableArray()
    var cellFrame : CGRect = CGRectZero
    override func viewDidLoad()
    {
        super.viewDidLoad()
        preUI()
        // Checking if sidemenu already created
        if isSideMenuAvailable == false
        {
            makeSideMenu()
            isSideMenuAvailable = true
        }
        preSetUp()

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
        dashboardCollectionView.dataSource = self
        dashboardCollectionView.delegate = self
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:1,left:10,bottom:10,right:10)
        layout.minimumInteritemSpacing = 5
        let heightScreen = Macros.ScreenSize.SCREEN_HEIGHT
        layout.minimumLineSpacing = heightScreen * 0.10 // Spacing in each cell from bottom in the collection view
        dashboardCollectionView.collectionViewLayout = layout
    }
    
    func preSetUp()
    {
        dashboardCollectionView!.registerNib(UINib(nibName: "DashboardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifierDashboardCollV)
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

    // Did Select Collection view item
    func pushVCForIndexPath(indexPath : NSIndexPath)
    {
        switch indexPath.row
        {
            case 0:

            break // 
            
            case 1:
            
            break //
            
            case 2:
            
            break //

            case 5:
            pushToRootVC()
            break //logout

            default:
            
            break //
            
        }
    }
    //Root view push
    func pushToRootVC()
    {
        SingletonStoryboard.sharedInstance.loginPushFromSingleton(self) { (success) -> Void in
            
        }
    }

    //MARK:- Delegates
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return collectionContentArray.count
    }
    
    func collectionView(collectionView: UICollectionView,
         layout collectionViewLayout: UICollectionViewLayout,
                sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        
        let width = Macros.ScreenSize.SCREEN_WIDTH
        return CGSize(width: width * 0.42  , height: width * 0.48 * 0.43)
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifierDashboardCollV, forIndexPath: indexPath) as! DashboardCollectionViewCell

        cell.backgroundColor=cell.contentView.backgroundColor
        cell.imgV.image = UIImage(named: collectionContentArray[indexPath.row] as! String)
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath)
    {
        // Getting collectionViewCell 
        
        Singleton.sharedInstance.disableWindowUserInteraction()
        
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell : DashboardCollectionViewCell? = collectionView.cellForItemAtIndexPath(indexPath) as? DashboardCollectionViewCell
        cell?.contentView.backgroundColor = nil
        cellFrame = (cell?.frame)!
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            cell!.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }, completion: {(finished: Bool) -> Void in
                UIView.animateWithDuration(0.25, animations: {() -> Void in
                    cell!.transform = CGAffineTransformIdentity
                    
                    Singleton.sharedInstance.delay(0.25, closure:
                        {
                        self.pushVCForIndexPath(indexPath)
                            Singleton.sharedInstance.enableWindowUserInteraction()

                    })
                })
        })

    }
}


