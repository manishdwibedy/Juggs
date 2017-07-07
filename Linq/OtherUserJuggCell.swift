//
//  OtherUserJuggCell.swift
//  Linq
//
//  Created by Quinton Askew on 6/30/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class OtherUserJuggCell: UITableViewCell {

    @IBOutlet weak var otherUserProfileImageView: UIImageView!
    @IBOutlet weak var juggTitle: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // visuals()
        
    }
    
    func visuals() {
        
        otherUserProfileImageView.layer.masksToBounds = true
        otherUserProfileImageView.layer.cornerRadius = 24
        
        
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
