//
//  FollowersTable.swift
//  Linq
//
//  Created by Quinton Askew on 6/20/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import KVNProgress

class FollowersTable: UITableViewController {

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        retrievefollowerUsers()
    }
    
    
    func retrievefollowerUsers(){
//        Globals.ShowSpinner(testStr: "")
        
        self.users.removeAll()
        self.tableView.reloadData()
        
        let ref = Database.database().reference()
//        let uid = Auth.auth().currentUser!.uid
        let childRef = ref.child("Users").child(UserIdRelations)
        
        childRef.child("Followers").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let userFollow = snapshot.value as? [String : AnyObject] {
                
//                var follower = Array(Set(userFollow))
                
                Globals.ShowSpinner(testStr: "")
                
                for(_, value) in userFollow {
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
                            userToShow.following = following
                            userToShow.follower = followers
                            userToShow.friendrequest = friendRequest
                            userToShow.privateUser = userPrivate
                            
                            self.users.append(userToShow)
                        }
                        
                        
                        self.users = Array(Set(self.users))
                        
                        Globals.HideSpinner()
                        let Dict:[String: Int] = ["userCount": self.users.count]
                        NotificationCenter.default.post(name: Notification.Name("followers"), object: nil, userInfo: Dict)
                        
                        self.tableView.reloadData()
                        
                    })
                }
                
                
            }
        })
        
        
    }
    

    
    func followed(_ sender: UIButton) {
        
//        KVNProgress.show(0.50, status: "Updating..")
        if let value = self.users[sender.tag].privateUser {
            if value == true {
                if self.users[sender.tag].friendrequest == nil {
                    let uid = Auth.auth().currentUser!.uid
                    let ref = Database.database().reference()
                    
                    let keyToPost = ref.child("Users").child(self.users[sender.tag].userID!)
                    let commentsRef = keyToPost.child("FriendRequest").childByAutoId()
                    
                    let friendRequest = [
                        "FromUserImage" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("urlToImage"),
                        "fromUser" : uid,
                        "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName")
                        ] as [String : Any]
                    
                    commentsRef.setValue(friendRequest)
                } else {
                    let reportArray  : [String:AnyObject] =  self.users[sender.tag].friendrequest
                    let uid = Auth.auth().currentUser!.uid
                    let ref = Database.database().reference()
                    
                    for(_,value) in reportArray  {
                        if value["fromUser"] as! String == uid  {
                            let alert = UIAlertController(title: "You have requested to follow \(self.users[sender.tag].firstName ?? "")", message: nil, preferredStyle: .alert)
                            let confirm = UIAlertAction(title: "OK", style: .default) { (action) in
                                
                            }
                            
                            alert.addAction(confirm)
                            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                            alert.view.tintColor = purp
                            self.navigationController!.present(alert, animated: true, completion: nil)
                            return;
                        }
                    }
                    
                    
                    
                    let keyToPost = ref.child("Users").child(self.users[sender.tag].userID!)
                    let commentsRef = keyToPost.child("FriendRequest").childByAutoId()
                    
                    let friendRequest = [
                        "FromUserImage" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("urlToImage"),
                        "fromUser" : uid,
                        "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName")
                        ] as [String : Any]
                    
                    commentsRef.setValue(friendRequest)
                }


            }
            else {
                let uid = Auth.auth().currentUser!.uid
                let ref = Database.database().reference()
                let userId = self.users[sender.tag].userID
                let keyToPost = ref.child("Users").child(uid)
                let commentsRef = keyToPost.child("Following").childByAutoId()
                commentsRef.setValue(userId)
                
                let post = ref.child("Users").child(userId!)
                post.child("Followers").childByAutoId().setValue(uid)
            }
        } else {
            let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
            let userId = self.users[sender.tag].userID
            let keyToPost = ref.child("Users").child(uid)
            let commentsRef = keyToPost.child("Following").childByAutoId()
            commentsRef.setValue(userId)
            
            let post = ref.child("Users").child(userId!)
            post.child("Followers").childByAutoId().setValue(uid)
        }
        
        
        
//        KVNProgress.showSuccess()
        
        retrievefollowerUsers()
        
    }
    
    
    func unfollowed(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let userId = self.users[sender.tag].userID
        
//        KVNProgress.show(0.50, status: "Updating..")
        
        let profile = ref.child("Users").child(uid).child("Following")
        profile.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let posts = snapshot.value as? [String : AnyObject]
            
            if posts != nil {
                for(key ,value) in posts! {
                    
                    if value as! String == userId!{
                        profile.child(key).removeValue()
                        
                        let profile1 = ref.child("Users").child(userId!).child("Followers")
                        
                        profile1.observe(.value, with: { (snapshot) -> Void in
                            
                            let posts1 = snapshot.value as? [String : AnyObject]
                            
                            if posts1 != nil {
                                for(key1,value1) in posts1! {
                                    
                                    if value1 as! String == uid {
                                        profile1.child(key1).removeValue()
                                    }
                                    
//                                    KVNProgress.showSuccess()
                
                                }
                                
                                profile.removeAllObservers()
                                profile1.removeAllObservers()
                                
                            } else {
//                                KVNProgress.showError()
                            }
                        })
                    } else {
//                        KVNProgress.showError()
                    }
                }
                self.retrievefollowerUsers()
            } else {
//                KVNProgress.showError()
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
        return users.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowersCell
        cell.followerName.text = self.users[indexPath.row].firstName! + " " + self.users[indexPath.row].lastName!
        cell.followerFrom.text = self.users[indexPath.row].city! + ", " + self.users[indexPath.row].state!
        cell.followerImage.sd_setImage(with: URL(string: "\(String(describing: users[(indexPath.row)].imagePath!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        
        let uid = Auth.auth().currentUser!.uid
        
        
        if ((self.users[indexPath.row].follower) != nil) {
            let dict  : [String:AnyObject] =  self.users[indexPath.row].follower
            
            let values = Array(dict.values) as! [String]
            
            cell.followBtn.tag = indexPath.row
            
            if values.contains(uid) {
                cell.followBtn.setTitle("Unfollow", for: .normal)
                cell.followBtn.addTarget(self, action: #selector(unfollowed(_:)), for: .touchUpInside)
            } else {
                cell.followBtn.setTitle("Follow", for: .normal)
                cell.followBtn.addTarget(self, action: #selector(followed(_:)), for: .touchUpInside)
            }
        } else {
            cell.followBtn.setTitle("Follow", for: .normal)
            cell.followBtn.addTarget(self, action: #selector(followed(_:)), for: .touchUpInside)
        }

        if self.users[indexPath.row].userID == uid {
            cell.followBtn.isEnabled = false
        }
        
        if ((self.users[indexPath.row].friendrequest) != nil) {
            let dict : [String:AnyObject] =  self.users[indexPath.row].friendrequest
            for(_,value) in dict {
                if value["fromUser"] as! String == uid  {
                    cell.followBtn.isHidden = false
                    cell.followBtn.setTitle("Pending", for: .normal)
                    cell.followBtn.isEnabled = false
                }
            }
        }

        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "showUserFromFollowers", sender: self)
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

    @IBAction func unwindToFollowers(segue:UIStoryboardSegue) { }
    // MARK: - Navigation
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserFromFollowers" {
            if let destination = segue.destination as? OtherUser {
                let indexPath = tableView.indexPathForSelectedRow?.row
                UserID = users[indexPath!].userID!
                destination.firstName = users[indexPath!].firstName!
                destination.lastName = users[indexPath!].lastName!
                destination.age = users[indexPath!].age!
                destination.city = users[indexPath!].city!
                destination.state = users[indexPath!].state!
                destination.gender = users[indexPath!].gender!
                destination.pathToImage = users[indexPath!].imagePath
                destination.messageSwipe.isEnabled = false
                destination.discoverSwipe.isEnabled = false
                destination.followingSwipe.isEnabled = false
                
            }
        }
    }
    

}
