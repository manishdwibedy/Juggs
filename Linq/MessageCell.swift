//
//  MessageCell.swift
//  Linq
//
//  Created by Quinton Askew on 5/29/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    /*
    var message: Message? {
        didSet {
            
            if let toID = message?.toID {
                let ref = Database.database().reference().child("Users").child(toID)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    print(snapshot)
                    
                }, withCancel: nil)
                
                
            }
        }
        
        
    }
    
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        visuals()
        
    }
    
    func visuals() {
        self.userImageView.translatesAutoresizingMaskIntoConstraints = true
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        self.userImageView.layer.borderWidth = 4
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        self.userImageView.layer.borderColor = purp.cgColor
        
    }
    
    
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
