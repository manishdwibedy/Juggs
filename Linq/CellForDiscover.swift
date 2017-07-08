//
//  CellForDiscover.swift
//  Linq
//
//  Created by Quinton Askew on 5/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class CellForDiscover: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    // @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var followingFalseImageView: UIImageView!
    @IBOutlet weak var followMeFalseImageView: UIImageView!
    @IBOutlet weak var followingTrueImageView: UIImageView!
    @IBOutlet weak var followMeTrueImageView: UIImageView!
    
    var userID: String!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.swipeView.isHidden = true
       // self.swipeView.isUserInteractionEnabled = true
        
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
//        swipe.direction = UISwipeGestureRecognizerDirection.left
//        self.swipeView.addGestureRecognizer(swipe)
        
    }
    
    
    
    
    
    
    
    
    
    
}
