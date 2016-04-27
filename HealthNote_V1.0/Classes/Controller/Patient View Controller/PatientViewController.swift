//
//  PatientViewController.swift
//  HealthNote_V1.0
//
//  Created by Manish on 4/25/16.
//  Copyright © 2016 iDev. All rights reserved.
//

import UIKit
import SideMenu
import ImagePicker
import RSKGrowingTextView
import ActionSheetPicker_3_0

let kCellIdentifierListTable: String = "listTableCellId"

class PatientViewController: UIViewController, ImagePickerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate
{
    var menuDashBoard: UIBarButtonItem!
    var growingTextView: RSKGrowingTextView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var profilePicRound: UIImageView!
    @IBOutlet var profilePicBase: UIImageView!
    @IBOutlet var listTable: UITableView!
    
    
    let imagePickerController = ImagePickerController()
    let  dataListArray :  NSMutableArray = NSMutableArray()
    var activeCell = NormalTableViewCell()
    var blackViewWithAlpha = UIView()
    let  pickerDataArray :  NSMutableArray = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        addGestureToImageView()
        preSetup()

    }

    override func viewDidLayoutSubviews()
    {
        
        preUI()
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
    //MARK:- UINavigation
    func addRightBarButtonWithImage()
    {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "addPatientDetails"), forState: UIControlState.Normal)
        button.addTarget(self, action:"addDetailsToParse", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame=CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }

    func toggleWindow()
    {
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true)
            {
                
        }
    }
    func applyEffect(yourView : UIView)
    {
        yourView.layer.shadowColor = UIColor.blackColor().CGColor
        yourView.layer.shadowOpacity = 1
        yourView.layer.shadowOffset = CGSizeZero
        yourView.layer.shadowRadius = 10
    }
    func preUI()
    {
        dispatch_async(dispatch_get_main_queue())
            {
                self.profilePicRound.layer.cornerRadius = self.profilePicRound.frame.size.height / 2.0
                self.profilePicRound.clipsToBounds = true
                self.profilePicRound.layer.opaque =  false
                self.profilePicRound.layer.shadowOffset = CGSizeZero
                self.profilePicRound.layer.shadowColor = UIColor.redColor().CGColor
                self.profilePicRound.layer.shadowOpacity = 0.8
                self.applyEffect(self.bottomView)
        }
    }
    func addGestureToImageView()
    {
        let tap = UITapGestureRecognizer(target: self, action:"imageViewTapped")
        profilePicRound.userInteractionEnabled = true
        profilePicRound .addGestureRecognizer(tap)
    }
    func imageViewTapped()
    {
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    //MARK:- Set up
    func preSetup()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true

        addLeftBarButtonWithImage()
        addRightBarButtonWithImage()
        
        listTable.dataSource  = self
        listTable.delegate = self
        let nib: UINib = UINib(nibName: "NormalTableViewCell", bundle: nil)
        listTable.registerNib(nib, forCellReuseIdentifier: kCellIdentifierListTable)
        
        // If array is nil from parse for testing purpose use mockData
        mockData()
        mockPickers()
        
    }
    func assignImageToProfile()
    {
        profilePicBase.image = UIImage(data:GlobalVariables.sharedManager.patientDetails.profilePicData)
        profilePicRound.image = UIImage(data:GlobalVariables.sharedManager.patientDetails.profilePicData)

    }
    func mockPickers()
    {
        let ageArray : NSMutableArray = NSMutableArray()
        let numbers = 1...120 // Setting range swift version.
        for number in numbers
        {
            ageArray .addObject("\(number)")
        }
        pickerDataArray .addObject(ageArray)
        
        let genderArray : NSMutableArray = NSMutableArray()
        genderArray .addObject("Male")
        genderArray .addObject("Female")
        pickerDataArray .addObject(genderArray)
        
        
        let heightArray : NSMutableArray = NSMutableArray()
        let numbersheightArray = 100...250 // Setting range swift version.
        for number in numbersheightArray
        {
            heightArray .addObject("\(number)")
        }
        pickerDataArray .addObject(heightArray)
        
        
        let weightArray : NSMutableArray = NSMutableArray()
        let numbersWeightArray = 10...150 // Setting range swift version.
        for number in numbersWeightArray
        {
            weightArray .addObject("\(number)")
        }
        pickerDataArray .addObject(weightArray)
    }
    func addDetailsToParse()
    {
        let model = HNPatient()

        if let data = UIImageJPEGRepresentation(profilePicBase.image!, 0.8)
        {
            model.profilePicData = data

        }else
        {
            model.profilePicData = NSData()

        }

        for obj in self.dataListArray
        {
            switch self.dataListArray .indexOfObject(obj)
            {
            case 0:
                model.name = obj.mainValue as! String
                break
                
            case 1:
                model.age = obj.mainValue as! String
                break

                
            case 2:
                model.gender = obj.mainValue as! String
                break

                
            case 3:
                model.height = obj.mainValue as! String
                break

                
            case 4:
                model.weight = obj.mainValue as! String

                break

                
            case 5:
                model.allergies = obj.mainValue as! String
                break

                
            case 6:
                model.medicalHistory = obj.mainValue as! String

                break

                
            case 7:
                model.emailId = obj.mainValue as! String

                break

                
            case 8:
                model.address = obj.mainValue as! String

                break

                
            case 9:
                model.phoneNumber = obj.mainValue as! String

                break

            default :
                
                break
            }
        }
        
        Singleton.sharedInstance.showLoaderWithTitle("saving...")
        
        HNParse.sharedInstance.parseSavePatientDetailsForCurrentUser(model) { (success, responseDic) -> () in
            Singleton.sharedInstance.hideLoader()
            if success == true
            {
                self.patientData(model as HNPatient)
            }
        }
    }

    func mockData()
    {
        if GlobalVariables.sharedManager.patientDetails == nil
        {
            HNParse.sharedInstance.parseGetPatientDetailsForCurrentUser({ (success, responseDic) -> () in
                if GlobalVariables.sharedManager.patientDetails != nil
                {
                    self.patientData(GlobalVariables.sharedManager.patientDetails as HNPatient)
                    self.assignImageToProfile()

                }else
                {
                    let model = HNPatient()
                    model.name   = ""
                    model.age    = ""
                    model.gender = ""
                    model.height = ""
                    model.weight = ""
                    model.allergies = ""
                    model.medicalHistory = ""
                    model.emailId = ""
                    model.address = ""
                    model.phoneNumber = ""
                    model.profilePicData = NSData()
                    self.patientData(model)
                }
            })
            
        }else
        {
            patientData(GlobalVariables.sharedManager.patientDetails as HNPatient)
            assignImageToProfile()
        }
    }
    func patientData(data : HNPatient)
    {
        let model = DataModel()
        model.name = "Name"
        model.mainValue = data.name
        model.type = .textField
        model.height = 42.0
        createModel(model) // Entry I
        
        let model2 = DataModel()
        model2.name = "Age"
        model2.mainValue = data.age
        model2.type = .picker
        model2.height = 42.0
        createModel(model2) // Entry II
        
        let model3 = DataModel()
        model3.name = "Gender"
        model3.mainValue = data.gender
        model3.type = .picker
        model3.height = 42.0
        createModel(model3) // Entry III
        
        let model4 = DataModel()
        model4.name = "Height"
        model4.mainValue = data.height
        model4.type = .picker
        model4.height = 42.0
        createModel(model4) // Entry IV
        
        
        let model5 = DataModel()
        model5.name = "Weight"
        model5.mainValue = data.weight
        model5.type = .picker
        model5.height = 42.0
        createModel(model5) // Entry V
        
        let model6 = DataModel()
        model6.name = "Allergies"
        model6.mainValue = data.allergies
        model6.type = .textView
        model6.height = 120.0
        createModel(model6) // Entry VI
        
        let model7 = DataModel()
        model7.name = "Medical History"
        model7.mainValue = data.medicalHistory
        model7.type = .textView
        model7.height = 140.0
        createModel(model7) // Entry VII
        
        
        let model8 = DataModel()
        model8.name = "Email id"
        model8.mainValue = data.emailId
        model8.type = .textField
        model8.height = 42.0
        createModel(model8) // Entry VIII
        
        let model9 = DataModel()
        model9.name = "Address"
        model9.mainValue = data.address
        model9.type = .textView
        model9.height = 140.0
        createModel(model9) // Entry IX

        
        let model10 = DataModel()
        model10.name = "Phone number"
        model10.mainValue = data.phoneNumber
        model10.type = .textField
        model10.height = 42.0
        createModel(model10) // Entry X
        listTable.reloadData()

    }
    func createModel(data : DataModel)
    {
        let model = DataModel()
        model.name = data.name
        model.mainValue = data.mainValue
        model.type = data.type
        model.height = data.height
        dataListArray .addObject(model)
    }
    //MARK:- Delegates Image Picker
    func wrapperDidPress(images: [UIImage])
    {
        imagePickerController .dismissViewControllerAnimated(true)
            {
                self.profilePicRound.image = images[0]
                self.profilePicBase.image = images[0]
        }
    }
    func doneButtonDidPress(images: [UIImage])
    {
        imagePickerController .dismissViewControllerAnimated(true)
            {
                self.profilePicRound.image = images[0]
                self.profilePicBase.image = images[0]
        }
    }
    func cancelButtonDidPress()
    {
        imagePickerController .dismissViewControllerAnimated(true)
            {
                
            }
    }
    func showTextFieldForCell(activeCell : NormalTableViewCell, indexPath : NSIndexPath)
    {
        let frame = CGRectMake(listTable.frame.origin.x , listTable.frame.origin.y + listTable.frame.size.height * 0.6, listTable.frame.size.width, listTable.frame.size.height * 0.12)
        let  textF = UITextField(frame: frame)
        textF.text = activeCell.detailValLbl?.text
        textF.tag = indexPath.row
        textF.center = CGPointMake(self.view.center.x, textF.center.y)
        textF.delegate = self
        textF.backgroundColor = UIColor.whiteColor()
        if indexPath.row == 9
        {
            textF.keyboardType = UIKeyboardType.NumberPad

        }else
        {
            textF.keyboardType = UIKeyboardType.Default

        }
        blackViewWithAlpha = UIView(frame: self.view.frame)
        blackViewWithAlpha.backgroundColor = UIColor.colorWithAlphaComponent(UIColor.blackColor())(0.5)
        listTable .userInteractionEnabled = false
        profilePicRound .userInteractionEnabled = false
        self.view .addSubview(blackViewWithAlpha)
        self.view .addSubview(textF)
        textF.becomeFirstResponder()
        
    }
    func showTextViewForCell(activeCell : NormalTableViewCell, indexPath : NSIndexPath)
    {
        let frame = CGRectMake(listTable.frame.origin.x , listTable.frame.origin.y + listTable.frame.size.height * 0.6, listTable.frame.size.width, listTable.frame.size.height * 0.12)
        growingTextView = RSKGrowingTextView(frame: frame)
        growingTextView.text = activeCell.detailValLbl?.text
        growingTextView.tag = indexPath.row
        growingTextView.center = CGPointMake(self.view.center.x, growingTextView.center.y)
        growingTextView.delegate = self
        
        blackViewWithAlpha = UIView(frame: self.view.frame)
        blackViewWithAlpha.backgroundColor = UIColor.colorWithAlphaComponent(UIColor.blackColor())(0.5)
        listTable .userInteractionEnabled = false
        profilePicRound .userInteractionEnabled = false
        self.view .addSubview(blackViewWithAlpha)
        self.view .addSubview(growingTextView)
        growingTextView.becomeFirstResponder()
        
    }
    func showPickerForCell(activeCell : NormalTableViewCell, indexPath : NSIndexPath, title : String, arrayData : NSArray)
    {
        blackViewWithAlpha = UIView(frame: self.view.frame)
        blackViewWithAlpha.backgroundColor = UIColor.colorWithAlphaComponent(UIColor.blackColor())(0.5)
        listTable .userInteractionEnabled = false
        profilePicRound .userInteractionEnabled = false
        self.view .addSubview(blackViewWithAlpha)
        
        // Add picker
        ActionSheetStringPicker.showPickerWithTitle(title, rows: arrayData as [AnyObject], initialSelection: 0, doneBlock: {
            picker, value, index in
            
            //            print("values = \(value)")
            //            print("indexes = \(index)")
            //            print("picker = \(picker)")
            
            self.listTable .userInteractionEnabled = true
            self.profilePicRound .userInteractionEnabled = true
            self.blackViewWithAlpha .removeFromSuperview()
            
            let model = self.dataListArray[indexPath.row] as? DataModel
            model?.mainValue = "\(index)"
            self.dataListArray .replaceObjectAtIndex(self.dataListArray .indexOfObject(model!), withObject: model!)
            self.listTable .userInteractionEnabled = true
            self.profilePicRound .userInteractionEnabled = true
            self.blackViewWithAlpha .removeFromSuperview()
            self.listTable.reloadData()
            
            return
            }, cancelBlock: { picker  -> Void in
                
                self.listTable .userInteractionEnabled = true
                self.profilePicRound .userInteractionEnabled = true
                self.blackViewWithAlpha .removeFromSuperview()
                
            }, origin: self.view)
        
        
    }
    
    //MARK:- TableView Delegate and Datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //variable type is inferred
        let cell: NormalTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifierListTable, forIndexPath: indexPath) as! NormalTableViewCell
        
        let model = self.dataListArray[indexPath.row] as? DataModel
        if let val = model?.mainValue
        {
            let uuidString:String = val as! String
            cell.detailValLbl.text  = uuidString
            
        }
        cell.nameLbl.text = model?.name
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let model = self.dataListArray[indexPath.row] as? DataModel
        return (model?.height)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let model = self.dataListArray[indexPath.row] as? DataModel
        return (model?.height)!
    }
    
    //select  mode
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        activeCell  = listTable.cellForRowAtIndexPath(indexPath) as! NormalTableViewCell
        switch indexPath.row
        {
        case 0:
            showTextFieldForCell(activeCell, indexPath: indexPath)
            break
            
        case 5:
            showTextViewForCell(activeCell, indexPath: indexPath)
            break
            
        case 6:
            showTextViewForCell(activeCell, indexPath: indexPath)
            break
            
        case 7:
            showTextFieldForCell(activeCell, indexPath: indexPath)
            break
            
            //Pickers
        case 1:
            showPickerForCell(activeCell, indexPath: indexPath, title: "Select Age", arrayData: pickerDataArray[0] as! NSArray)
            break
            
        case 2:
            showPickerForCell(activeCell, indexPath: indexPath, title: "Select Gender", arrayData: pickerDataArray[1] as! NSArray)
            break
            
        case 3:
            showPickerForCell(activeCell, indexPath: indexPath, title: "Select Height - cm's ", arrayData: pickerDataArray[2] as! NSArray)
            break
            
        case 4:
            showPickerForCell(activeCell, indexPath: indexPath, title: "Select Weight - Kg's", arrayData: pickerDataArray[3] as! NSArray)
            break
            
        case 8:
            showTextViewForCell(activeCell, indexPath: indexPath)
            break

        case 9:
            showTextFieldForCell(activeCell, indexPath: indexPath)
            break

        default:
            
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK:- Delegates UITextView
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    {
        return true
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool
    {
            switch textView.tag
            {
            case 5: // Allergies
                
                break
                
            case 6: // Medical History
                
                break

            case 8: // Address
                
                break

                
            default:
                
                break
            }
        
        return true
    }
    func textViewDidEndEditing(textView: UITextView)
    {
        let model = self.dataListArray[textView.tag] as? DataModel
        model?.mainValue = textView.text
        self.dataListArray .replaceObjectAtIndex(self.dataListArray .indexOfObject(model!), withObject: model!)
        growingTextView.text = " "
        growingTextView .removeFromSuperview()
        blackViewWithAlpha .removeFromSuperview()
        listTable .userInteractionEnabled = true
        profilePicRound .userInteractionEnabled = true
        
        listTable .reloadData()
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        switch textField.tag
        {
        case 0: // Name
            
            break
            
        case 7: // email
            
            break

            
        case 9: // Phone Number
            
            break

            
        default:
            
            break
        }
        
        return true

    }
    func textFieldDidEndEditing(textField: UITextField)
    {
        let model = self.dataListArray[textField.tag] as? DataModel
        model?.mainValue = textField.text
        self.dataListArray .replaceObjectAtIndex(self.dataListArray .indexOfObject(model!), withObject: model!)
        textField.text = " "
        textField .removeFromSuperview()
        blackViewWithAlpha .removeFromSuperview()
        listTable .userInteractionEnabled = true
        profilePicRound .userInteractionEnabled = true
        listTable .reloadData()
        
    }
    //MARK:- Picker Delegate and datasource
    //    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    //        return 1
    //    }
    //
    //    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    //    {
    //        return self.creditCardToken.count;
    //    }
    //
    //    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    //    {
    //        return (self.creditCardToken[row] as! String)
    //    }
    //    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    //    {
    //        
    //    }
    
}


class DataModel: NSObject
{
    override init()
    {
        super.init()
    }
    
    var name : String!
    var mainValue : AnyObject!
    var type : TypeObj!
    var height : CGFloat!
    
}
enum TypeObj
{
    case numPad
    case textField
    case textView
    case picker
    
}


