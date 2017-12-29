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
   
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var SubTitle: UILabel!
    @IBOutlet weak var viewUserBtn: UIButton!

    var message: Message? {
        didSet {
            
            let uid = Auth.auth().currentUser?.uid
            var userToFetch = ""
            if message?.fromId == uid {
                userToFetch = (message?.toId)!
            } else {
                userToFetch = (message?.fromId)!
            }
            

                let ref = Database.database().reference().child("Users").child(userToFetch)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dict = snapshot.value as? [String: AnyObject] {
                        let firstName = dict["FirstName"] as? String
                        let lastName = dict["LastName"] as? String
                        let fullName = firstName! + " " + lastName!
                        self.Title?.text = fullName
                        self.Title?.textColor = UIColor.white
                        
                        
                        if let profilePicURL = dict["urlToImage"] as? String {
                            self.UserImage.loadImageUsingCacheWithUrlString(profilePicURL)
                            self.UserImage.translatesAutoresizingMaskIntoConstraints = true
                            self.UserImage.layer.cornerRadius = self.UserImage.frame.size.width/2
                            self.UserImage.clipsToBounds = true
                            self.UserImage.contentMode = .scaleAspectFill
                            


                        }

                    }
                    
                }, withCancel: nil)
            
            
            if self.message?.text == nil {
                self.SubTitle?.text = "Attachment: 1 Image"
            } else {
                self.SubTitle?.text = self.message?.text
            }
            
            self.SubTitle?.textColor = UIColor.white
            
            if let seconds = self.message?.timestamp.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                self.timeLabel.text = dateFormatter.string(from: timestampDate)
            }

            
        }
    }
    
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "messageCell")
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        //need x,y,width,height anchors
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
    
    
    
    
}



