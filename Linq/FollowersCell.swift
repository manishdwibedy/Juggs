//
//  FollowersCell.swift
//  Linq
//
//  Created by Quinton Askew on 6/25/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class FollowersCell: UITableViewCell {

    @IBOutlet weak var followerImage: UIImageView!
    @IBOutlet weak var followerName: UILabel!
    @IBOutlet weak var followerFrom: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var unfollowBtn: UIButton!
 
    @IBAction func followed(_ sender: Any) {
        
        //        let uid = Auth.auth().currentUser!.uid
        //        let ref = Database.database().reference()
        //        let key = ref.child("Users").childByAutoId().key
        //
        
//        let uid = Auth.auth().currentUser!.uid
//        let ref = Database.database().reference()
//        let userId = self.users[sender].userID
//        let keyToPost = ref.child("Users").child(uid)
//        let commentsRef = keyToPost.child("Following").childByAutoId()
//        commentsRef.setValue(userId)
        
        //           _ = (sender as AnyObject).tag
    }
    
    @IBAction func unfollowed(_ sender: Any) {
   
    }
  
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        visuals()
        
    }

    
    func visuals() {
        
        followerImage.layer.masksToBounds = true
        followerImage.layer.cornerRadius = 24
        followBtn.layer.borderColor = UIColor.white.cgColor
        followBtn.layer.borderWidth = 2
    }
    
        
  /*  func follow(row: Int) {
      
        let indexPath = self.superview?.indexPathForSelectedRow!.row
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let key = ref.child("Users").childByAutoId().key
        
        var isFollower = false
        
        ref.child("Users").child(uid).child("Following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as? String == self.users[indexPath].userID {
                        isFollower = true
                        
                        ref.child("Users").child(uid).child("Following/\(ke)").removeValue()
                        ref.child("Users").child(self.users[indexPath].userID!).child("Followers/\(ke)").removeValue()
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                }
            }
            if !isFollower {
                let following = ["Following/\(key)" : self.users[indexPath].userID]
                let followers = ["Followers/\(key)" : uid]
                
                ref.child("Users").child(uid).updateChildValues(following as Any as! [AnyHashable : Any])
                ref.child("Users").child(self.users[indexPath].userID!).updateChildValues(followers)
                
                
                
            }
        })
        ref.removeAllObservers()
        
    }
     */

   



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
