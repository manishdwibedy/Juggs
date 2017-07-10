//
//  Request.swift
//  Linq
//
//  Created by Quinton Askew on 6/3/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

//If you tap the user's image, segue to their profile.

class RequestCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var blurrForSpec: UIVisualEffectView!
    
    @IBOutlet weak var specBtn: UIButton!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        visuals()
    }

    func visuals() {
        
        blurrForSpec.layer.masksToBounds = true
        blurrForSpec.layer.cornerRadius = 8
        
        specBtn.layer.masksToBounds = true
        specBtn.layer.cornerRadius = 8
        
        acceptButton.layer.masksToBounds = true
        acceptButton.layer.cornerRadius = 8
        declineButton.layer.masksToBounds = true
        declineButton.layer.cornerRadius = 8
        
    }

}
