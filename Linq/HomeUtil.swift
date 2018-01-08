//
//  HomeUtil.swift
//  Linq
//
//  Created by Quinton Askew on 12/29/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import CoreLocation

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

class HomeUtil: NSObject{
    struct Instance {
        static var homePostList = [Post]()
        static var homeUtil = HomeUtil()
        static var locationManager = CLLocationManager()
    }
    
    // Move Jugg to Archive after 24 Hrs
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let hours = (ti / 3600)
        return NSString(format: "%0.2d",hours)
    }
    
    
    func storeKMorMilesSettings(value:String) {
        UserDefaults.standard.set(value, forKey: KM_MILES_KEY)
    }
    func getKMorMilesSettings() -> String {
        if UserDefaults.standard.value(forKey: KM_MILES_KEY) == nil{
            return "Miles"
        }
        return UserDefaults.standard.value(forKey: KM_MILES_KEY) as! String
    }
}
