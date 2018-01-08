//
//  Post.swift
//  Linq
//
//  Created by Quinton Askew on 5/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleMobileAds
class Post: NSObject {
    
    var author: String!
    var likes: Int!
    var capacity: Int!
    var CapacityCount: Int!
    var userID: String!
    var postID: String!
    var juggCount: Int!
    var pathToImage: String! // Flyer for Jugg.
    var pathToUserImage: String! // Host of Jugg.
    var AP: String!
    var address: String!
    var moveDesc: String!
    var movePrivate: Bool!
    var time: String!
    var date: String!
    var peopleWhoLiked: [String] = [String]()
    var peopleWhoLinked: [String] = [String]()
    var distance : String!
    
    var nameOfEvent: String!
    var commentsForPost: [Any]?
    var message: String!
//    var city: String!
//    var state: String!
    var ref: Database!
    var requests : [String:Any]?
    var invites : [String:Any]?
    var adViewObject: GADNativeExpressAdView!
    
    
     var latitudePost: Double!
     var longitudePost: Double!
    
    var distanceKM : String!

}
