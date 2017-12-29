//
//  MessagesTable.swift
//  Linq
//
//  Created by Quinton Askew on 5/29/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class MessagesTable: UITableViewController {
    
    
    var users = [User]()
    var messages = [Message]()
    var messagesDict = [String : Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = #imageLiteral(resourceName: "NoMessageBGD")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Messages...")
        refreshControl?.addTarget(self, action: #selector(MessagesTable.observeMessages), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!) // not required when using UITableViewController

        observeMessages()
    }
    
    func observeMessages() {
        

        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("user-messages").child(uid!)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid!).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                
                let messagesReference = Database.database().reference().child("messages").child(messageId)
                messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let message = Message()
                        message.setValuesForKeys(dictionary)
                        if let chatPartnerId = message.chatPartnerId() {
                            self.messagesDict[chatPartnerId] = message
                        }
                        
                        self.messages = Array(self.messagesDict.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            
                            return (message1.timestamp?.int32Value)! > (message2.timestamp?.int32Value)!
                        })
                        
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.tableView.reloadData()
                        })
                        

                    }
                    
                    
                })
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        self.refreshControl?.endRefreshing()
        self.refreshControl?.isUserInteractionEnabled = true

        
    }
   
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            let ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid
            
            var otherUserID = ""
            if messages[indexPath.row].fromId == uid {
                otherUserID = messages[indexPath.row].toId
            } else {
                otherUserID =  messages[indexPath.row].fromId
            }
            
            ref.child("user-messages").child(uid!).child(otherUserID).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                let messagesRef = Database.database().reference().child("messages").child(messageId)
                
                messagesRef.removeValue(completionBlock: { (error , reference) in
                    ref.child("user-messages").child(uid!).child(otherUserID).child(messageId).removeValue()
                    ref.child("user-messages").child(otherUserID).child(uid!).child(messageId).removeValue()
                })
                
            })
            
            
            self.messages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
        }
    }
    
    
    func tapGestureForProfile() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
        let navController = UINavigationController(rootViewController: vc)
        vc.discoverSwipe.isEnabled = false
        vc.followersSwipe.isEnabled = false
        vc.followingSwipe.isEnabled = false
        self.present(navController, animated: true, completion: nil)
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("Users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dict)
            user.userID = chatPartnerId
            user.firstName = dict["FirstName"] as! String
            user.imagePath = dict["urlToImage"] as! String
            self.showChatControllerForUser(user,index: indexPath)
        }, withCancel: nil)
        
        
    }
    
    func showChatControllerForUser(_ user: User, index:IndexPath) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        navigationController?.navigationBar.tintColor = purp
    
        let cell = tableView.cellForRow(at: index) as! MessageCell

        chatLogController.title = cell.Title.text
      
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    
    @IBAction func unwindToMessages(segue:UIStoryboardSegue) { }
    
    
    
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     } */
    
    
}
extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

