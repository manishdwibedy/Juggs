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

    }

    override func viewWillAppear(_ animated: Bool) {
        retrievefollowingUsers()
    }
    
    func retrievefollowingUsers(){
        
        let ref = Database.database().reference()
        //let uid = Auth.auth().currentUser!.uid
        let childRef = ref.child("Users").child(UserIdRelations)
        
        childRef.child("Following").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let users = snapshot.value as? [String : AnyObject] {
                
                Globals.ShowSpinner(testStr: "")
                
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
    
    func unfollowing(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let userId = self.users[sender.tag].userID
      
        let profile = ref.child("Users").child(uid).child("Following")
        profile.observe(.value, with: { (snapshot) -> Void in
            
            let posts = snapshot.value as? [String : AnyObject]
            
            if posts != nil {
                for(key ,value) in posts! {
                    
                    if value as! String == userId!{
//                        print(value)
                        profile.child(key).removeValue()
                        
                        let profile1 = ref.child("Users").child(userId!).child("Followers")
                        
                        profile1.observe(.value, with: { (snapshot) -> Void in
                            
                            let posts = snapshot.value as? [String : AnyObject]
                            
                            if posts != nil {
                                for(key ,value) in posts! {
                                    
                                    if value as! String == uid {
                                        profile.child(key).removeValue()
                                    }
                                }
                                
                                self.users.remove(at: sender.tag)
                                
                                self.tableView.reloadData()
                                
                                profile.removeAllObservers()
                                profile1.removeAllObservers()
                            }
                            
                            
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
   
//        cell.followBtn.tag = indexPath.row
        cell.unFollowBtn.tag = indexPath.row
        cell.unFollowBtn.addTarget(self, action: #selector(unfollowing(_:)), for: .touchUpInside)
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
