//
//  BlockedCell.swift
//  Linq
//
//  Created by Quinton Askew on 8/23/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class BlockedCell: UITableViewCell {

    @IBOutlet weak var imageUser: UIImageView!
   
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var unBlockBtn: UIButton!
    
    @IBOutlet weak var userBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageUser.clipsToBounds = true
        imageUser.layer.cornerRadius = imageUser.frame.size.width / 2
        imageUser.layer.borderWidth = 2
        imageUser.layer.borderColor = purp
        
        unBlockBtn.layer.masksToBounds = true
        unBlockBtn.layer.cornerRadius = 6
        unBlockBtn.layer.borderWidth = 2
        unBlockBtn.layer.borderColor = UIColor.green.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
