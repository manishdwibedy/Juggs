//
//  BlockedTable.swift
//  Linq
//
//  Created by Quinton Askew on 8/23/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class BlockedTable: UITableViewController {
    
    
    var blockedList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        
        ref.child("Users").child(uid).child("Block").observe(.value, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String : AnyObject]
            {
                //                print(dictionary)
                self.blockedList.removeAll()
                for (_ ,value) in dictionary {
                    if let user = value as? String {
                        ref.child("Users").child(user).observeSingleEvent(of: DataEventType.value, with: { (snap) in
                            
                            let dict = [String : AnyObject]()
                            let userToShow = User(dictionary:dict)
                            let value = snap.value as! [String : AnyObject]
                            
                            let userID = value["UID"] as? String
                            let firstName = value["FirstName"] as? String
                            let lastName = value["LastName"] as? String
                            let age = value["Age"] as? String
                            let city = value["City"] as? String
                            let gender = value["Gender"] as? String
                            let state = value["State"] as? String
                            let bio = value["Bio"] as? String
                            let followers = value["Followers"] as? [String: AnyObject]
                            let following = value["Following"] as? [String: AnyObject]
                            let friendRequest = value["FriendRequest"] as? [String:AnyObject]
                            let imagePath = value["urlToImage"] as? String
                            let userPrivate = value["UserPrivate"] as? Bool
                            
                            userToShow.userID = userID
                            userToShow.firstName = firstName
                            userToShow.lastName = lastName
                            userToShow.age = age
                            userToShow.bio = bio
                            userToShow.city = city
                            userToShow.gender = gender
                            userToShow.state = state
                            userToShow.imagePath = imagePath
                            userToShow.follower = followers
                            userToShow.following = following
                            userToShow.friendrequest = friendRequest
                            userToShow.privateUser = userPrivate
                            
                            self.blockedList.append(userToShow)
                            self.tableView.reloadData()
                        })
                    }
                }
                
                
            }
        })
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return blockedList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let blockedCell = tableView.dequeueReusableCell(withIdentifier: "blockedCell", for: indexPath) as! BlockedCell
        
        let userItem = self.blockedList[indexPath.row]
        
        blockedCell.nameLabel.text = userItem.firstName! + " " + userItem.lastName!
        blockedCell.fromLabel.text = userItem.city! + ", " + userItem.state!
        blockedCell.imageUser.sd_setImage(with: URL(string: "\(String(describing: userItem.imagePath!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        blockedCell.userBtn.tag = indexPath.row
        blockedCell.unBlockBtn.tag = indexPath.row
        
        blockedCell.userBtn.addTarget(self, action: #selector(buttonProfile(_:)), for: UIControlEvents.touchUpInside)
        
        blockedCell.unBlockBtn.addTarget(self, action: #selector(buttonUnBlock(_:)), for: UIControlEvents.touchUpInside)
        
        return blockedCell
        
    }
    
    
    func buttonUnBlock(_ sender : UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        
        ref.child("Users").child(uid).child("Block").observe(.value, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String : AnyObject]
            {
                for (key,value) in dictionary {
                    
                    if value as? String == self.blockedList[sender.tag].userID {
                        ref.child("Users").child(uid).child("Block").child(key).removeValue()
                        self.blockedList.remove(at: sender.tag)
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    
    func buttonProfile(_ sender: UIButton) {
        
        let ref = Database.database().reference()
        
        ref.child("Users").child(self.blockedList[sender.tag].userID!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            let users = snapshot.value as! [String : AnyObject]
            
            let  firstName = users["FirstName"] as? String
            let lastName = users["LastName"] as? String
            let age = users["Age"] as? String
            let city = users["City"] as? String
            let gender = users["Gender"] as? String
            let state = users["State"] as? String
            let bio = users["Bio"] as? String
            // let followers = users["Followers"] as? [String: AnyObject]
            // let following = users["Following"] as? [String: AnyObject]
            let imagePath = users["urlToImage"] as? String
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
            
            let navController = UINavigationController(rootViewController: vc)
            
            vc.firstName = firstName!
            vc.lastName = lastName!
            vc.age = age!
            vc.city = city!
            vc.state = state!
            vc.gender = gender!
            vc.pathToImage = imagePath!
            vc.bioTextForOtherUser = bio!
            
            vc.urlTextForOtherUser = "No URL Available."
            vc.discoverSwipe.isEnabled = true
            vc.followersSwipe.isEnabled = false
            vc.followingSwipe.isEnabled = false
            
            self.present(navController, animated: true, completion: nil)
        })
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
