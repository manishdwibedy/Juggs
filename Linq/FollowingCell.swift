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
        
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        
        followingImage.layer.masksToBounds = false
        followingImage.layer.cornerRadius = followingImage.frame.height/2
        followingImage.clipsToBounds = true
        followingImage.layer.borderWidth = 2
        followingImage.layer.borderColor = purp.cgColor
        unFollowBtn.layer.borderColor = UIColor.white.cgColor
        unFollowBtn.layer.borderWidth = 2
        unFollowBtn.layer.cornerRadius = 8
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
