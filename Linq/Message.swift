//
//  Message.swift
//  Linq
//
//  Created by Quinton Askew on 5/29/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    
    var toId: String!
    var fromId: String!
    var text: String!
    var timestamp: NSNumber!
    var imageUrl: String!
    
//    init(dictionary: [String: Any]) {
//        self.fromID = dictionary["fromId"] as? String
//        self.text = dictionary["text"] as? String
//        self.toID = dictionary["toId"] as? String
//        self.time = dictionary["timestamp"] as? NSNumber
//    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
