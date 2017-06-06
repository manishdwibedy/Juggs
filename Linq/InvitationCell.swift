//
//  InvitationCell.swift
//  Linq
//
//  Created by Quinton Askew on 6/3/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

// This class should display past events that were within 100 miles, and ones you "Linq'ed"

class InvitationCell: UITableViewCell {

    
    @IBOutlet weak var flyerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var moveName = ""
    var imagePath = ""
    var message = ""
    var time = ""
    var date = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
