//
//  Globals.swift
//  More Questions
//
//  Created by gagan arora on 4/28/17.
//  Copyright © 2017 gagan arora. All rights reserved.
//

import UIKit
import SwiftSpinner

@objc class Globals: NSObject {
    
        
    // MARK:============== Singleton Object=======
    static let sharedInstance: Globals = {
        let instance = Globals()
        // setup code
        return instance
    }()
  

    // MARK:============== User Defaulst value Get and Set=======
    func saveValuetoUserDefaultsWithKeyandValue(_ value:Any, key: String){
        
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    func removeValuetoUserDefaultsWithKey( _ key: String){
        
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getValueFromUserDefaultsForKey(_ key: String) -> Any!{
        if let value = UserDefaults.standard.value(forKey: key){
            return value as Any!
        }else{
            return nil
        }
    }
    func getValueFromUserDefaultsForKey_Path(_ keyPath:String) -> Any! {
        if let value = UserDefaults.standard.value(forKeyPath: keyPath)
        {
            return value as Any!
        }else {
            return nil
        }
        
    }
    func updateCustomAddressValuestoUserDefaultsForKey(_ key:String, value:String, forDefaultKey:String, forKeyPath:Bool) {
        
        if var savedObj = Globals.sharedInstance.getValueFromUserDefaultsForKey(forDefaultKey) as? [String:Any]
        {
            
            if var dict = savedObj["custom"] as? [String:Any]{
                dict[key] = value as Any?
                
                savedObj["custom"] = dict as Any?
                Globals.sharedInstance.saveValuetoUserDefaultsWithKeyandValue(savedObj as Any, key: forDefaultKey)
            }
        }
    }
    func updateValuetoUserDefaultsForKey(_ key:String, value:String, forDefaultKey:String) {
        
        if var savedObj = Globals.sharedInstance.getValueFromUserDefaultsForKey(forDefaultKey) as? [String:Any]
        {
            
            print(savedObj)
            if let _ = savedObj[key] {
                savedObj[key] = value as Any?
            }
            else {
                savedObj[key] = value as Any?
            }
            
            print(savedObj)
            
            Globals.sharedInstance.saveValuetoUserDefaultsWithKeyandValue(savedObj as Any, key: forDefaultKey)
        }
    }
    
    // MARK:-============= date Formator Methods =========
    func dateFromTimestamp(_ timeStamp:Double) -> String{
        let date:Date = Date(timeIntervalSinceNow: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    // MARK :- get Minutes for user Wait for Car Arival
    func getCurrentDate() -> String {
        let today: Date = Date()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString: String = dateFormat.string(from: today)
        return dateString
    }
    
    // MARK :- get Minutes for user Wait for Car Arival
    func getCurrentDateforOndemandCars() -> String {
        let today: Date = Date()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString: String = dateFormat.string(from: today)
        return dateString
    }
    func getDateFormatForDateString(_ date:String) -> String{
        //changing dates format
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm aa"
        // changed line in your code
        let current_Date: Date = dateFormatter.date(from: date)!
        let dateFormatter2: DateFormatter = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm"
        // changed line in your code
        let dateText: String = dateFormatter2.string(from: current_Date)
        NSLog("the object value is:%@", dateText)
        //
        return dateText
    }
    
    // MARK:-======== Set Corner and Border Witdh  ======
    
    class func layoutViewFor(_ view:UIView?, color:UIColor?, width:CGFloat?, cornerRadius:CGFloat)
    {
        if view != nil {
            if color != nil && width != nil {
                view!.layer.borderColor = color!.cgColor
                view!.layer.borderWidth = width!
            }
            view!.layer.cornerRadius = cornerRadius
            view!.layer.masksToBounds = true
            view!.clipsToBounds = true
        }
    }
    class func layoutViewForBorder(_ view:UIView?)
    {
        if view != nil {
            view!.layer.borderColor = UIColor.white.cgColor
            view!.layer.borderWidth = 1
            view!.clipsToBounds = true
        }
        
    }
    // MARK:-===Font Methods for iPAd=====

    class func defaultAppFontiPad() -> UIFont {
        return UIFont(name: "", size: 18.0)!
    }
    class func defaultAppFontItalic(_ size:Float) -> UIFont {
        return UIFont(name: "", size: CGFloat(size))!
    }
    class func defaultAppFontWithBoldiPadSize() -> UIFont {
        return UIFont(name: "", size: 18.0)!
    }

    class func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    class func textFieldDidChange(textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! < 6 {
            return false
        }else{
            return true
        }
    }
    func PhoneNOValidate(textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! > 10 {
            return false
        }else{
            return true
        }
    }
    class func ShowSpinner(testStr:String){
        SwiftSpinner.show(testStr)
    }
    
    class func HideSpinner(){
        SwiftSpinner.hide()
    }
    class func LogoutUser(){
        Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue("", key: "USER_ID")
        Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue("", key: "TOTALPOINTS")
        Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue("", key: "USERNAME")
        Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue("", key: "EMAIL")
        Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue("", key: "REFERALCODE")
        Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(false, key: "IS_LOGIN")
        
    }
}// class brackets
