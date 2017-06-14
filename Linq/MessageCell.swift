//
//  MessageCell.swift
//  Linq
//
//  Created by Quinton Askew on 5/29/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
   
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userImageView.translatesAutoresizingMaskIntoConstraints = true        
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        self.userImageView.layer.borderWidth = 4
        let blueGreenThemeColor = UIColor.white
        self.userImageView.layer.borderColor = blueGreenThemeColor.cgColor

    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
