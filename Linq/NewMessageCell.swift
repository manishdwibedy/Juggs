//
//  NewMessageCell.swift
//  Linq
//
//  Created by Quinton Askew on 7/16/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class NewMessageCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        visuals()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func visuals()
    {
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.layer.borderWidth = 2
        userImageView.layer.borderColor = purp.cgColor
        nameLabel.textColor = UIColor.white
        fromLabel.textColor = UIColor.white
        
    }
    
    
    
    
    
    
    
}
