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

    var moveName = ""
    var imagePath = ""
    var message = ""
    var time = ""
    var date = ""
    
    @IBOutlet weak var flyerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var optOutBtn: UIButton!
    
    @IBAction func invitationAccepted(_ sender: Any) {
        
        confirmAcceptAlert()
    
    }
    
    @IBAction func invitationDeclined(_ sender: Any) {
        
        confirmDeclinedAlert()
   
    }
    
    @IBAction func optedOut(_ sender: Any) {
        
        // Send attending users notification saying I opted-out and can't attend.
        
        
        // Decrement capacity
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        visuals()
        
    }

    func visuals() {
        optOutBtn.isEnabled = false
        optOutBtn.isHidden = true
        responseLabel.isHidden = true
        flyerImageView.layer.masksToBounds = true
        flyerImageView.layer.cornerRadius = 8
        acceptBtn.layer.cornerRadius = 8
        declineBtn.layer.cornerRadius = 8
        
    }
    
   
    func confirmAcceptAlert() {
        
        let alert = UIAlertController(title: "Confirm your decision to continue.", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (action) in
            // increment capacity label on Jugg table
            
            // Notify Host and other users who are attending 
            
            // Drop pin for Jugg's address on map.
            
            // Hide buttons and show opt out.
            self.acceptBtn.isHidden = true
            self.declineBtn.isHidden = true
            self.optOutBtn.isHidden = false
            self.optOutBtn.isEnabled = true
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        
        UIApplication.shared.keyWindow?.rootViewController?.navigationController?.topViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    func confirmDeclinedAlert() {
        
        let alert = UIAlertController(title: "Confirm your decision to continue.", message: nil, preferredStyle: .alert)
        let decline = UIAlertAction(title: "Decline", style: .default) { (action) in
            
            // Notify Host that I declined
            
            // Hide buttons and show label.
            self.acceptBtn.isHidden = true
            self.declineBtn.isHidden = true
            self.responseLabel.isHidden = false
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(decline)
        alert.addAction(cancel)
        UIApplication.shared.keyWindow?.rootViewController?.navigationController?.topViewController?.present(alert, animated: true, completion: nil)
        
    }


    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
