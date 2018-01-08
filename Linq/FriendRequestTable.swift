//
//  FriendRequestTable.swift
//  Linq
//
//  Created by Quinton Askew on 7/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class FriendRequestTable: UITableViewController {

    var arrayRequests = [FriendRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        
        let childRef = ref.child("Users").child(uid).child("FriendRequest")
            
        childRef.observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                self.arrayRequests.removeAll()
                
                
                for(_,value) in dictionary {
                    
                    let fromUser = value["fromUser"] as? String
                    let FromUserImage = value["FromUserImage"] as? String
                    let fromName = value["fromName"] as? String
                    
                    let request = FriendRequest()
                    request.fromUser = fromUser
                    request.FromUserImage = FromUserImage
                    request.fromName = fromName
                    
                    self.arrayRequests.append(request)
                }
                
                self.tableView.reloadData()
            }
            
        })

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
        return arrayRequests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendRequestCell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell", for: indexPath) as! FriendRequestCell

        let request = arrayRequests[indexPath.row]
        friendRequestCell.nameLabel.text = request.fromName
        friendRequestCell.fromLabel.text = ""
        friendRequestCell.requestingFriendImageView .sd_setImage(with: URL.init(string: request.FromUserImage))
        
        friendRequestCell.acceptBtn.tag = indexPath.row
        friendRequestCell.declineBtn.tag = indexPath.row
        
        friendRequestCell.acceptBtn.addTarget(self, action: #selector(acceptRequest(_:)), for: .touchUpInside)
        friendRequestCell.declineBtn.addTarget(self, action: #selector(declineRequest(_:)), for: .touchUpInside)
        
        friendRequestCell.btnProfile.tag = indexPath.row
        friendRequestCell.btnProfile.addTarget(self, action: #selector(buttonProfile(_:)), for: UIControlEvents.touchUpInside)
        
        
        return friendRequestCell
    }
    
    func declineRequest (_ sender: UIButton) {
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        let userId = arrayRequests[sender.tag].fromUser
        
        let childRef = ref.child("Users").child(uid).child("FriendRequest")
        childRef.observeSingleEvent(of: .value, with: { (snaphot) in
            
            if let dictionary = snaphot.value as? [String:AnyObject] {
                for(key,value) in dictionary  {
                    if value["fromUser"] as? String == userId {
                        childRef.child(key).removeValue()
                        self.arrayRequests.remove(at: sender.tag)
                        self.tableView.reloadData()
                    }
                }
            }
            
        })
        
    }
    
    
    func acceptRequest (_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let userId = self.arrayRequests[sender.tag].fromUser
        let keyToPost = ref.child("Users").child(userId!)
        let commentsRef = keyToPost.child("Following").childByAutoId()
        commentsRef.setValue(uid)
        
        let post = ref.child("Users").child(uid)
        post.child("Followers").childByAutoId().setValue(userId)
        
        let childRef = ref.child("Users").child(uid).child("FriendRequest")
        childRef.observeSingleEvent(of: .value, with: { (snaphot) in
            
            if let dictionary = snaphot.value as? [String:AnyObject] {
                for(key,value) in dictionary  {
                    if value["fromUser"] as? String == userId {
                        childRef.child(key).removeValue()
                        self.arrayRequests.remove(at: sender.tag)
                        self.tableView.reloadData()
                    }
                }
            }
            
        })
        
    }
    
    func buttonProfile(_ sender: UIButton) {
        
        let ref = Database.database().reference()
    ref.child("Users").child(self.arrayRequests[sender.tag].fromUser).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
