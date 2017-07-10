//
//  AttendeesCell.swift
//  Linq
//
//  Created by Quinton Askew on 7/4/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class AttendeesCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageAndGenderLabel: UILabel!
  
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
