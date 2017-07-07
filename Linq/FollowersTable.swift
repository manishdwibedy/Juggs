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

class FollowersTable: UITableViewController {

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        retrieveUsers()
        
         retrievefollowerUsers()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        retrievefollowerUsers()
    }
    
    func retrievefollowerUsers(){
        Globals.ShowSpinner(testStr: "")
        
        self.users.removeAll()

        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        let childRef = ref.child("Users").child(uid)
        
        childRef.child("Followers").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let users = snapshot.value as? [String : AnyObject] {
                for(_, value) in users {
                    print(value)
                    //let childfor = ref.child("Users").child("value")
                    ref.child("Users").child(value as! String).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                        
                        if let dict = snapshot.value as? [String : AnyObject] {
                            
                            let userToShow = User(dictionary:dict)
                            
                            let firstName = dict["First Name"] as? String
                            let lastName = dict["Last Name"] as? String
                            let age = dict["Age"] as? String
                            let city = dict["City"] as? String
                            let gender = dict["Gender"] as? String
                            let state = dict["State"] as? String
                            let bio = dict["Bio"] as? String
                            let imagePath = dict["urlToImage"] as? String
                            let followers = dict["Followers"] as? [String: AnyObject]
                            let following = dict["Following"] as? [String: AnyObject]

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
                            
                            self.users.append(userToShow)
                        }
                        Globals.HideSpinner()
                        self.tableView.reloadData()
                    })
                }
                
                
            }
        })
        
        
    }
    
    
    func retrieveUsers() {
        Globals.ShowSpinner(testStr: "")
        let ref = Database.database().reference()
        
        ref.child("Users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            self.users.removeAll()
            for(_, value) in users {
                
                if let uid = value["UID"] as? String {
                    if uid != Auth.auth().currentUser!.uid {
                        let dict = [String : AnyObject]()
                        let userToShow = User(dictionary:dict)
                        if let userID = value["UID"] as? String,
                            let  firstName = value["First Name"] as? String,
                            let lastName = value["Last Name"] as? String,
                            let age = value["Age"] as? String,
                            let city = value["City"] as? String,
                            let gender = value["Gender"] as? String,
                            let state = value["State"] as? String,
                            let bio = value["Bio"] as? String,
                            let imagePath = value["urlToImage"] as? String {
                            userToShow.userID = userID
                            userToShow.firstName = firstName
                            userToShow.lastName = lastName
                            userToShow.age = age
                            userToShow.bio = bio
                            userToShow.city = city
                            userToShow.gender = gender
                            userToShow.state = state
                            userToShow.imagePath = imagePath
                            self.users.append(userToShow)
                            
                            
                        }
                        
                        
                    }
                    
                }
            }
            Globals.HideSpinner()
            self.tableView.reloadData()
            
        })
        ref.removeAllObservers()
        
        
        
    }
    
    
    
  /*  func follow(row: Int) {
     //   let indexPath = self.tableView.indexPathForSelectedRow!.row
        
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
                        
                            //self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
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
        
    } */
    

    
    
    
    
    
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
        cell.followerName.text = self.users[indexPath.row].firstName + " " + self.users[indexPath.row].lastName
        cell.followerFrom.text = self.users[indexPath.row].city + ", " + self.users[indexPath.row].state
        cell.followerImage.sd_setImage(with: URL(string: "\(String(describing: users[(indexPath.row)].imagePath!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        
        let uid = Auth.auth().currentUser!.uid
        
        let dict  : [String:AnyObject] =  self.users[indexPath.row].following
        let values = Array(dict.values) as! [String]
        
        cell.followBtn.tag = indexPath.row
        
        if values.contains(uid) {
            cell.followBtn.setTitle("Unfollow", for: .normal)
            cell.followBtn.addTarget(self, action: #selector(unfollowed(_:)), for: .touchUpInside)
        } else {
            cell.followBtn.setTitle("Follow", for: .normal)
            cell.followBtn.addTarget(self, action: #selector(followed(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "showUserFromFollowers", sender: self)
    }
    
    func followed(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let userId = self.users[sender.tag].userID
        let keyToPost = ref.child("Users").child(uid)
        let commentsRef = keyToPost.child("Following").childByAutoId()
        commentsRef.setValue(userId)
        
        let post = ref.child("Users").child(userId!)
        post.child("Followers").childByAutoId().setValue(uid)
        
        retrievefollowerUsers()
        
    }
    
    func unfollowed(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let userId = self.users[sender.tag].userID
        let keyToPost = ref.child("Users").child(uid)
        let commentsRef = keyToPost.child("Following")
//        commentsRef.child(userId).key.removeAll()
        
//        commentsRef.setValue(userId)
//        
//        let post = ref.child("Users").child(userId!)
//        post.child("Followers").childByAutoId().setValue(uid)
        
//        retrievefollowerUsers()
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
                destination.firstName = users[indexPath!].firstName
                destination.lastName = users[indexPath!].lastName
                destination.age = users[indexPath!].age
                destination.city = users[indexPath!].city
                destination.state = users[indexPath!].state
                destination.gender = users[indexPath!].gender
                destination.pathToImage = users[indexPath!].imagePath
                destination.messageSwipe.isEnabled = false
                destination.discoverSwipe.isEnabled = false
                destination.followingSwipe.isEnabled = false
                
            }
        }
    }
    

}
