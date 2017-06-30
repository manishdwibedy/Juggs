//
//  CommentsCell.swift
//  Linq
//
//  Created by Quinton Askew on 6/19/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentLbl: UITextView!
    @IBOutlet weak var userLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
