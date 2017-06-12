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
    
    
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let backButton = UIButton()
        backButton.sizeToFit()
        let backImage = UIImage(named: "box")
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(Inbox.goBack), for: UIControlEvents.touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = -15
        
        self.navigationItem.leftBarButtonItems = [spacer,backBarButton]
        
        observeMessages()
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        
        let ref = Database.database().reference().child("Messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                print(message.text)
                
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    
                })
                
            }
            
            
            
        }, withCancel: nil )
        
        
    
    
        
    }
    
    
    
    
    
   
    func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func sendMessage() {
        
      let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let toID = user?.userID!
        let fromID = Auth.auth().currentUser!.uid
        //let time = NSNumber(value: Date().timeIntervalSinceNow)
        let time = "\(Date().timeIntervalSince1970)"
        let values = ["Text" : self.textField.text!, "toID" : toID, "fromID" : fromID, "time" : time]
        childRef.updateChildValues(values as Any as! [AnyHashable : Any])
        
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
   /*     if let toId = message.toID {
            
            let ref = Database.database().reference().child("Users").child(toId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dict = snapshot.value as? [String : AnyObject] {
                    
                    cell.textLabel?.text = dict["First Name"] as? String
                    
                }
                
                
            }, withCancel: nil)
            
            
        } */
        
        
        
        cell.textLabel?.text = message.text
        return cell
    }

      
    
    
    
    
    
    
}
