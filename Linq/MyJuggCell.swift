//
//  MyJuggCell.swift
//  Linq
//
//  Created by Quinton Askew on 7/2/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class MyJuggCell: UITableViewCell {

 
    @IBOutlet weak var juggNameLabel: UILabel!
    @IBOutlet weak var locationOfJuggLabel: UILabel!
    @IBOutlet weak var juggFlyerImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
