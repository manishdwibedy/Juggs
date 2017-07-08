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

        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView

         observeMessages()
    }

    func observeMessages() {
        
        let ref = Database.database().reference().child("Messages")
      

        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let message = Message(dictionary: dictionary)
                message.setValuesForKeys(dictionary)
              //  self.messages.append(message)
                
                if let toID = message.toID {
                    self.messagesDict[toID] = message
                    self.messages = Array(self.messagesDict.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    
                })
                
            }
            
            
            
        }, withCancel: nil )
        
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(MessagesTable.tapGestureForProfile))
        //cell.profileImageView.addGestureRecognizer(tap)
        cell.profileImageView.isUserInteractionEnabled = true
        cell.viewUserBtn.addGestureRecognizer(tap)
        return cell
    }
  
    
    func tapGestureForProfile() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
        let navController = UINavigationController(rootViewController: vc)
   //     let userIndex = self.tableView.indexPathForSelectedRow?.row
    //    let firstName = self.users[userIndex!].firstName
     //   let lastName = self.users[userIndex!].lastName
     //   let fullName = firstName! + " " + lastName!
      //  vc.title = fullName
       // vc.age = self.users[userIndex!].age
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
        guard let dictionary = snapshot.value as? [String: AnyObject] else {
            return
        }
        
        let user = User(dictionary: dictionary)
        user.userID = chatPartnerId
        self.showChatControllerForUser(user)
        
    }, withCancel: nil)

    
}
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user

        chatLogController.title = "User Name Here"
        navigationController?.pushViewController(chatLogController, animated: true)
    }

    
    @IBAction func unwindToMessages(segue:UIStoryboardSegue) { }
    
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("New message")
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 /*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if  segue.identifier == "messageToUser" {
            let destination = segue.destination as? OtherUser
            let userIndex = tableView.indexPathForSelectedRow?.row
            let firstName = self.users[userIndex!].firstName
            let lastName = self.users[userIndex!].lastName
             let fullName = firstName! + " " + lastName!
          //  destination?.otherUserName = fullName
            
            
            
            
        }
    } */
    

}
extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
