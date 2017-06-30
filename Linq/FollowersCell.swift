//
//  FollowersCell.swift
//  Linq
//
//  Created by Quinton Askew on 6/25/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class FollowersCell: UITableViewCell {

    @IBOutlet weak var followerImage: UIImageView!
    @IBOutlet weak var followerName: UILabel!
    @IBOutlet weak var followerFrom: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var unfollowBtn: UIButton!
    @IBAction func followed(_ sender: Any) {
    
    
    
    
    }
    @IBAction func unfollowed(_ sender: Any) {
   
    
    
    
    
    
    }
  
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        visuals()
        
    }

    
    func visuals() {
        
        followerImage.layer.masksToBounds = true
        followerImage.layer.cornerRadius = 24
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
