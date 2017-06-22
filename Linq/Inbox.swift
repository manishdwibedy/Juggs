//
//  Inbox.swift
//  Linq
//
//  Created by Quinton Askew on 5/29/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase


class Inbox: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBAction func messageSent(_ sender: Any) {
    sendMessage()
    
    }
    
   
    @IBOutlet weak var tableView: UITableView!
    
    var user: User? {
        didSet {
            navigationItem.title = user?.firstName
            
            observeMessages()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        visuals()
        
        
        
        
        
        observeMessages()
    }
    
    var messages = [Message]()
    
    func visuals() {
        
        let backButton = UIButton()
        backButton.sizeToFit()
        let backImage = UIImage(named: "box")
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(Inbox.goBack), for: UIControlEvents.touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = -15
        
        self.navigationItem.leftBarButtonItems = [spacer,backBarButton]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
    }
    
    func goBack() {
        dismiss(animated: true, completion: nil)
    }
           
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.userID else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message(dictionary: dictionary)
                
                //do we need to attempt filtering anymore?
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                 //   self.collectionView?.reloadData()
                })
                
            }, withCancel: nil)
            
        }, withCancel: nil)

//        let ref = Database.database().reference().child("Messages")
//        ref.observe(.childAdded, with: { (snapshot) in
//            
//            if let dictionary = snapshot.value as? [String : AnyObject] {
//                
//                let message = Message()
//                message.setValuesForKeys(dictionary)
//                self.messages.append(message)
//                print(message.text)
//                
//                
//                DispatchQueue.main.async(execute: {
//                    self.tableView.reloadData()
//                    
//                })
//            }
//        }, withCancel: nil )
    }
    
    
    func sendMessage() {
        
      let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let toID = user!.userID! //Empty so I used static
        let fromID = Auth.auth().currentUser!.uid
        //let time = NSNumber(value: Date().timeIntervalSinceNow)
        let time = "\(Date().timeIntervalSince1970)"
        let values = ["Text" : self.textField.text!, "toID" : toID, "fromID" : fromID, "time" : time] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toID)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let message = messages[indexPath.row]
      //  if let toId = message.toID {
            
      //      let ref = Database.database().reference().child("Users").child(toId)
     //       ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
      //          if let dict = snapshot.value as? [String : AnyObject] {
                    
                    cell.textLabel?.text = message.toID
                    cell.detailTextLabel?.text = message.text
                    
             //   }
                
                
         //   }, withCancel: nil)
            
            
   //     }
        
        
        
        return cell
    }

    
} // End Of Class
