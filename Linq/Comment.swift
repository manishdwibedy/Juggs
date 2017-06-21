//
//  Comment.swift
//  Linq
//
//  Created by Quinton Askew on 6/19/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//


import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage


struct Comment {
    var userImageStringUrl: String!
    var postId: String!
    var content: String!
    var username: String!
    var ref: DatabaseReference?
    var key: String!
    
    
    init(postId: String, userImageStringUrl: String, content: String, username: String, key: String = ""){
        
        self.content = content
        self.postId = postId
        self.username = username
        self.userImageStringUrl = userImageStringUrl
        self.ref = Database.database().reference()
        
        
    }
    
    init(snapshot: DataSnapshot){
        let snap = snapshot.value as! [String : AnyObject]
        self.content = snap["Content"] as! String
        self.postId = snap["PostId"] as! String
        self.username = snap["username"] as! String
        self.userImageStringUrl = snap["userImageStringUrl"] as! String
        self.key = snapshot.key
        self.ref = snapshot.ref
        
        
    }
    
    func toAnyObject() -> [String: AnyObject] {
        
        return ["userImageStringUrl": userImageStringUrl as AnyObject, "content": content as AnyObject,"username": username as AnyObject,"postId":postId as AnyObject]
    }
    
    
}
