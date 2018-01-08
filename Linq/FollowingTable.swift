//
//  FollowingTable.swift
//  Linq
//
//  Created by Quinton Askew on 6/20/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import KVNProgress

class FollowingTable: UITableViewController {

    var followingUsers = [User]()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        retrievefollowingUsers()
    }
    
   public func retrievefollowingUsers(){
        
        self.followingUsers.removeAll()
        self.tableView.reloadData()
        let ref = Database.database().reference()
        let childRef = ref.child("Users").child(UserIdRelations)
    
        childRef.child("Following").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let followUsers = snapshot.value as? [String : AnyObject] {
                
                Globals.ShowSpinner(testStr: "")
                
                for(_, value) in followUsers  {
//                    print(value)
                    //let childfor = ref.child("Users").child("value")
                    ref.child("Users").child(value as! String).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                        
                        if let dict = snapshot.value as? [String : AnyObject] {
                            
                            let userToShow = User(dictionary:dict)
                            
                            let firstName = dict["FirstName"] as? String
                            let lastName = dict["LastName"] as? String
                            let age = dict["Age"] as? String
                            let city = dict["City"] as? String
                            let gender = dict["Gender"] as? String
                            let state = dict["State"] as? String
                            let bio = dict["Bio"] as? String
                            let imagePath = dict["urlToImage"] as? String
                            let followers = dict["Followers"] as? [String: AnyObject]
                            let following = dict["Following"] as? [String: AnyObject]
                            let friendRequest = value["FriendRequest"] as? [String:AnyObject]
                            let userPrivate = value["UserPrivate"] as? Bool
                            
                            
                            userToShow.userID = value as? String
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
                            
                            self.followingUsers.append(userToShow)
                            
                        }
                        
                        self.followingUsers = Array(Set(self.followingUsers))
                        
                        Globals.HideSpinner()
                        let Dict:[String: Int] = ["userCount": self.followingUsers.count]
                        NotificationCenter.default.post(name: Notification.Name("following"), object: nil, userInfo: Dict)
                        
                        self.tableView.reloadData()
                    })
                }
                
                
            }
        })
    
        
    }
    
    func unfollowing(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        if let userId = self.followingUsers[sender.tag].userID {
            let profile = ref.child("Users").child(uid).child("Following")
            profile.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let posts = snapshot.value as? [String : AnyObject]
                
                if posts != nil {
                    for(key ,value) in posts! {
                        
                        if value as! String == userId{
                            profile.child(key).removeValue()
                            
                            let profile1 = ref.child("Users").child(userId).child("Followers")
                            
                            profile1.observe(.value, with: { (snapshot) -> Void in
                                
                                let posts1 = snapshot.value as? [String : AnyObject]
                                
                                if posts1 != nil {
                                    for(key1,value1) in posts1! {
                                        
                                        if value1 as! String == uid {
                                            profile1.child(key1).removeValue()
                                        }
                                        
                                    }
                                    profile.removeAllObservers()
                                    profile1.removeAllObservers()
                                    
                                    
                                } else {
                                   
                                }
                            })
                        } else  {
                           
                        }
                    }
                    self.retrievefollowingUsers()
                } else {
                    
                }
            })
        }
       
        
    }
   
    
    
    func followed(_ sender: UIButton) {
        
//        KVNProgress.show(0.50, status: "Updating..")
        
        if let value = self.followingUsers[sender.tag].privateUser {
            if (value == true) {
                if self.followingUsers[sender.tag].friendrequest == nil {
                    let uid = Auth.auth().currentUser!.uid
                    let ref = Database.database().reference()
                    
                    let keyToPost = ref.child("Users").child(self.followingUsers[sender.tag].userID!)
                    let commentsRef = keyToPost.child("FriendRequest").childByAutoId()
                    
                    let friendRequest = [
                        "FromUserImage" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("urlToImage"),
                        "fromUser" : uid,
                        "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName")
                        ] as [String : Any]
                    
                    commentsRef.setValue(friendRequest)
                    
                } else {
                    let reportArray  : [String:AnyObject] =  self.followingUsers[sender.tag].friendrequest
                    let uid = Auth.auth().currentUser!.uid
                    let ref = Database.database().reference()
                    
                    for(_,value) in reportArray  {
                        if value["fromUser"] as! String == uid  {
                            let alert = UIAlertController(title: "You have requested to follow \(self.followingUsers[sender.tag].firstName ?? "")", message: nil, preferredStyle: .alert)
                            let confirm = UIAlertAction(title: "OK", style: .default) { (action) in
                                
                            }
                            
                            alert.addAction(confirm)
                            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                            alert.view.tintColor = purp
                            self.navigationController!.present(alert, animated: true, completion: nil)
                            return;
                        }
                    }
                    
                    
                    
                    let keyToPost = ref.child("Users").child(self.followingUsers[sender.tag].userID!)
                    let commentsRef = keyToPost.child("FriendRequest").childByAutoId()
                    
                    let friendRequest = [
                        "FromUserImage" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("urlToImage"),
                        "fromUser" : uid,
                        "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName")
                        ] as [String : Any]
                    
                    commentsRef.setValue(friendRequest)
                }
            } else {
                let uid = Auth.auth().currentUser!.uid
                let ref = Database.database().reference()
                let userId = self.followingUsers[sender.tag].userID
                let keyToPost = ref.child("Users").child(uid)
                let commentsRef = keyToPost.child("Following").childByAutoId()
                commentsRef.setValue(userId)
                
                let post = ref.child("Users").child(userId!)
                post.child("Followers").childByAutoId().setValue(uid)
            }
            
            
        } else {
            let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
            let userId = self.followingUsers[sender.tag].userID
            let keyToPost = ref.child("Users").child(uid)
            let commentsRef = keyToPost.child("Following").childByAutoId()
            commentsRef.setValue(userId)
            
            let post = ref.child("Users").child(userId!)
            post.child("Followers").childByAutoId().setValue(uid)
        }
        
        
        
//        KVNProgress.showSuccess()
        
        retrievefollowingUsers()
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return followingUsers.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowingCell
        
        cell.followingName.text = self.followingUsers[indexPath.row].firstName! + " " + self.followingUsers[indexPath.row].lastName!
        cell.followingFrom.text = self.followingUsers[indexPath.row].city! + ", " + self.followingUsers[indexPath.row].state!
        cell.followingImage.sd_setImage(with: URL(string: "\(String(describing: followingUsers[(indexPath.row)].imagePath!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
   
        cell.unFollowBtn.tag = indexPath.row
        
        let uid = Auth.auth().currentUser!.uid
        
        if ((self.followingUsers[indexPath.row].follower) != nil) {
            let dict  : [String:AnyObject] =  self.followingUsers[indexPath.row].follower
            
            let values = Array(dict.values) as! [String]

            
            if values.contains(uid) {
                cell.unFollowBtn.setTitle("Unfollow", for: .normal)
                cell.unFollowBtn.addTarget(self, action: #selector(unfollowing(_:)), for: .touchUpInside)
            } else {
                cell.unFollowBtn.setTitle("Follow", for: .normal)
                cell.unFollowBtn.addTarget(self, action: #selector(followed(_:)), for: .touchUpInside)
            }
        } else {
            cell.unFollowBtn.setTitle("Follow", for: .normal)
            cell.unFollowBtn.addTarget(self, action: #selector(followed(_:)), for: .touchUpInside)
        }
        
        if self.followingUsers[indexPath.row].userID == uid {
            cell.unFollowBtn.isEnabled = false
        }
        
        if ((self.followingUsers[indexPath.row].friendrequest) != nil) {
            let dict : [String:AnyObject] =  self.followingUsers[indexPath.row].friendrequest
            for(_,value) in dict {
                if value["fromUser"] as! String == uid  {
                    cell.unFollowBtn.isHidden = false
                    cell.unFollowBtn.setTitle("Pending", for: .normal)
                    cell.unFollowBtn.isEnabled = false
                }
            }
        }
        
        cell.selectionStyle = .none

        // Configure the cell...

        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "showUserFromFollowing", sender: self)
    }

    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        cell!.contentView.backgroundColor = purp
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = .clear
    }
    
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation
    
    @IBAction func unwindToFollowing(segue:UIStoryboardSegue) { }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserFromFollowing" {
        if let destination = segue.destination as? OtherUser {
            let indexPath = tableView.indexPathForSelectedRow?.row
            UserID = followingUsers[indexPath!].userID!
            destination.firstName = followingUsers[indexPath!].firstName!
            destination.lastName = followingUsers[indexPath!].lastName!
            destination.age = followingUsers[indexPath!].age!
            destination.city = followingUsers[indexPath!].city!
            destination.state = followingUsers[indexPath!].state!
            destination.gender = followingUsers[indexPath!].gender!
            destination.pathToImage = followingUsers[indexPath!].imagePath
            destination.messageSwipe.isEnabled = false
            destination.discoverSwipe.isEnabled = false
            destination.followersSwipe.isEnabled = false
            destination.followingSwipe.isEnabled = true
            
            }
        }
    
    }

}
