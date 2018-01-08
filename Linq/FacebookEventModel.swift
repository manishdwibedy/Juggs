//
//  FacebookEventModel.swift
//  Linq
//
//  Created by Yatish on 11/19/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class FacebookEvents : NSObject {
    
    var id                 : String?
    var start_time         : String?
    var end_time           : String?
    var fbdescription      : String?
    var name               : String?
    var place              : Place?
    var practice_area      : String?
    var coverImage         : String?
   
    
    convenience init(_ attributes: [String: Any]) {
        self.init()
        
        self.id              = attributes["id"] as? String
        self.start_time      = attributes["start_time"] as? String
        self.end_time        = attributes["end_time"] as? String
        self.fbdescription   = attributes["description"] as? String
        self.name            = attributes["name"] as? String
        self.practice_area   = attributes["practice_area"] as? String
        let coverData        = attributes["cover"] as? [String : Any]
        self.coverImage      = coverData?["source"] as? String
        guard let getData = attributes["place"] as? [String : Any],let getLocation = getData["location"] as? [String : Any] else{
            return
        }
        let place = Place()
        
         place.city       = getLocation["city"] as? String
         place.country    = getLocation["country"] as? String
         place.longitude  = getLocation["longitude"] as? Double
         place.latitude   = getLocation["latitude"] as? Double
         place.street     = getLocation["street"] as? String
         place.name       = getData["name"] as? String
         self.place = place
        
       
    }
}

class Place : NSObject {
    
    var city           : String?
    var country        : String?
    var latitude       : Double?
    var longitude      : Double?
    var street         : String?
    var name           : String?
    var id             : String?
}

