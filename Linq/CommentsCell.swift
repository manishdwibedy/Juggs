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
        visuals()
    }

    func visuals() {
        
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        
        userImageView.layer.masksToBounds = false
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 2
        userImageView.layer.borderColor = purp.cgColor
       
    }

    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
