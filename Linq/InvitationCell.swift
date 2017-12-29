//
//  InvitationCell.swift
//  Linq
//
//  Created by Quinton Askew on 6/3/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class InvitationCell: UITableViewCell {

    var moveName = ""
    var imagePath = ""
    var message = ""
    var time = ""
    var date = ""
    var userImagePath = ""
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var flyerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var optOutBtn: UIButton!
    @IBOutlet weak var speculationBtn: UIButton!
    
    @IBOutlet weak var widthAcceptConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnProfile: UIButton!

    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        visuals()
        
    }

    func visuals()
    {
        
        flyerImageView.layer.masksToBounds = true
        flyerImageView.layer.cornerRadius = 8
       
        acceptBtn.layer.masksToBounds = true
        acceptBtn.layer.cornerRadius = 8
        acceptBtn.layer.borderWidth = 2
        acceptBtn.layer.borderColor = UIColor.green.cgColor
        
        
        declineBtn.layer.masksToBounds = true
        declineBtn.layer.cornerRadius = 8
        declineBtn.layer.borderWidth = 2
        declineBtn.layer.borderColor = UIColor.red.cgColor
        
        speculationBtn.layer.masksToBounds = true
        speculationBtn.layer.cornerRadius = 8
        speculationBtn.layer.borderWidth = 2
        speculationBtn.layer.borderColor = purp
        
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.layer.borderWidth = 2
        userImageView.layer.borderColor = purp
        
    }
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
