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

class FollowingTable: UITableViewController {

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//    retrieveUsers()
       
        
    
    }

   override func viewWillAppear(_ animated: Bool) {
        retrievefollowingUsers()
    }
    
    func retrievefollowingUsers(){
         Globals.ShowSpinner(testStr: "")
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        let childRef = ref.child("Users").child(uid)
        
        childRef.child("Following").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
                            userToShow.follower = followers
                            userToShow.following = following

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
        
     //   let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
      //  let key = ref.child("Users").childByAutoId().key
        ref.child("Users").observeSingleEvent(of: .value, with: { snapshot in
            //.child(uid).child("Following")
            
            if let users = snapshot.value as? [String : AnyObject] {
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
//                            self.users.append(userToShow)
                            
                            
                        }
                        
                        
                  }
                }
                }
            }
            Globals.HideSpinner()
            self.tableView.reloadData()
            
        })
        ref.removeAllObservers()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowingCell
        
        cell.followingName.text = self.users[indexPath.row].firstName + " " + self.users[indexPath.row].lastName
        cell.followingFrom.text = self.users[indexPath.row].city + ", " + self.users[indexPath.row].state
        cell.followingImage.sd_setImage(with: URL(string: "\(String(describing: users[(indexPath.row)].imagePath!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))

        cell.followBtn.tag = indexPath.row
        cell.unFollowBtn.tag = indexPath.row
        cell.unFollowBtn.addTarget(self, action: #selector(unfollowing(_:)), for: .touchUpInside)
        
        // Configure the cell...

        return cell
    }
   
    func unfollowing(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let userId = self.users[sender.tag].userID
        let keyToPost = ref.child("Users").child(uid)
        let commentsRef = keyToPost.child("Following")
        
        //        commentsRef.removeValue()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "showUserFromFollowing", sender: self)
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
            destination.firstName = users[indexPath!].firstName
            destination.lastName = users[indexPath!].lastName
            destination.age = users[indexPath!].age
            destination.city = users[indexPath!].city
            destination.state = users[indexPath!].state
            destination.gender = users[indexPath!].gender
            destination.pathToImage = users[indexPath!].imagePath
            destination.messageSwipe.isEnabled = false
            destination.discoverSwipe.isEnabled = false
            destination.followersSwipe.isEnabled = false
            destination.followingSwipe.isEnabled = true
            
            }
        }
    
    }

}
