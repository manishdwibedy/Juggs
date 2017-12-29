//
//  CommentObj.swift
//  Linq
//
//  Created by gagan arora on 6/30/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CommentObj: NSObject {
    var UserName: String!
    var UserImageUrl: String!
    var Cotent: String!
    var ref: DatabaseReference!
    var timestamp : Double!
}
