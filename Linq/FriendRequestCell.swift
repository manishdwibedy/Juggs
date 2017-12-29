//
//  FriendRequestCell.swift
//  Linq
//
//  Created by Quinton Askew on 7/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {

    @IBOutlet weak var requestingFriendImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    
    @IBOutlet weak var btnProfile: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
            visuals()
    }
    
    
    func visuals()
    {
      requestingFriendImageView.clipsToBounds = true
      requestingFriendImageView.layer.cornerRadius = requestingFriendImageView.frame.size.width / 2
      requestingFriendImageView.layer.borderWidth = 2
      requestingFriendImageView.layer.borderColor = purp
        
      acceptBtn.layer.masksToBounds = true
      acceptBtn.layer.cornerRadius = 6
      acceptBtn.layer.borderWidth = 2
      acceptBtn.layer.borderColor = UIColor.green.cgColor
        
      declineBtn.layer.masksToBounds = true
      declineBtn.layer.cornerRadius = 6
      declineBtn.layer.borderWidth = 2
      declineBtn.layer.borderColor = UIColor.red.cgColor
        
    
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
