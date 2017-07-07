//
//  FollowingCell.swift
//  Linq
//
//  Created by Quinton Askew on 6/25/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class FollowingCell: UITableViewCell {
    
    @IBOutlet weak var followingImage: UIImageView!
    
    @IBOutlet weak var followingName: UILabel!
    @IBOutlet weak var followingFrom: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var unFollowBtn: UIButton!

    @IBAction func followed(_ sender: Any) {
   
    
    }
    
    @IBAction func unfollowed(_ sender: Any) {
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        visuals()
    }
    
    
    func visuals() {
        
        followingImage.layer.masksToBounds = true
        followingImage.layer.cornerRadius = 24
        unFollowBtn.layer.borderColor = UIColor.white.cgColor
        unFollowBtn.layer.borderWidth = 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
