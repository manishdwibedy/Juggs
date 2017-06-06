//
//  ArchiveCell.swift
//  Linq
//
//  Created by Quinton Askew on 6/4/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class ArchiveCell: UITableViewCell {

    @IBOutlet weak var flyerImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var linkedImage: UIImageView!
    @IBOutlet weak var linkedCountLabel: UILabel!
    @IBOutlet weak var likedImage: UIImageView!
    @IBOutlet weak var likedLabelCount: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
