//
//  Request.swift
//  Linq
//
//  Created by Quinton Askew on 6/3/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

//If you tap the userImageView, segue to their profile.

class RequestCell: UITableViewCell {
 
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImage: UIImageView! // Flyer
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var blurrView: UIVisualEffectView!

    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var speculationBtn: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var widthDeclineConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        visuals()
    }

    func visuals()
    {
  
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0).cgColor
        
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.layer.borderWidth = 2
        userImageView.layer.borderColor = purp
        
        acceptButton.layer.masksToBounds = true
        acceptButton.layer.cornerRadius = 8
        acceptButton.layer.borderWidth = 2
        acceptButton.layer.borderColor = UIColor.green.cgColor
        
        declineButton.layer.masksToBounds = true
        declineButton.layer.cornerRadius = 8
        declineButton.layer.borderWidth = 2
        declineButton.layer.borderColor = UIColor.red.cgColor
        
     
        speculationBtn.layer.masksToBounds = true
        speculationBtn.layer.cornerRadius = 8
        speculationBtn.layer.borderWidth = 2
        speculationBtn.layer.borderColor = purp
        
    }

}
