//
//  User.swift
//  Linq
//
//  Created by Quinton Askew on 5/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
// import MapKit

class User: NSObject {
    
    var userID: String?
    var firstName: String!
    var lastName: String!
    var age: String!
    var city: String!
    var gender: String!
    var state: String!
    var bio: String!
    var imagePath: String!
    var following: [String:AnyObject]!
    var follower: [String:AnyObject]!
    var friendrequest: [String:AnyObject]!
    var privateUser : Bool!
    
    init(dictionary: [String: AnyObject]) {
        userID = dictionary["id"] as? String
        firstName = dictionary["name"] as? String
        //self.email = dictionary["email"] as? String
        imagePath = dictionary["profileImageUrl"] as? String
    }

   // var gradientView: UIView!
    //let locationManager = CLLocationManager()
    //var userLatitude:CLLocationDegrees! = 0
    //var userLongitude:CLLocationDegrees! = 0
    
    
    
}
