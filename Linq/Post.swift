//
//  Post.swift
//  Linq
//
//  Created by Quinton Askew on 5/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Post: NSObject {
    
    var author: String!
    var likes: Int!
    var capacity: Int!
    var userID: String!
    var postID: String!
    var flameCount: Int!
    var pathToImage: String!
    var pathToUserImage: String!
    var AP: String!
    var address: String!
    var moveDesc: String!
    var movePrivate: String!
    var time: String!
    var date: String!
    var peopleWhoLiked: [String] = [String]()
    var nameOfEvent: String!
    var pathToFlyer: String!
    var commentsForPost: [Any]?
    var message: String!
    var ref: DatabaseReference!
}
