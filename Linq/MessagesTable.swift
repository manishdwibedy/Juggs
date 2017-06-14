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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView

       fetchUsers()
    }

    func fetchUsers() {
        let ref = Database.database().reference()
        ref.child("Users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String : AnyObject]
            self.users.removeAll()
            for(_, value) in users {
                let userToShow = User()
                if let uid = value["UID"] as? String {
                    if uid != Auth.auth().currentUser!.uid {
                  
                        if let userID = value["UID"] as? String,
                        let  firstName = value["First Name"] as? String,
                        let lastName = value["Last Name"] as? String,
                        let imagePath = value["urlToImage"] as? String {
                            userToShow.userID = userID
                            userToShow.firstName = firstName
                            userToShow.lastName = lastName
                            userToShow.imagePath = imagePath
                            self.users.append(userToShow)
                        
                        }
                    
                    
                    }
                    
                }
            }
            
            self.tableView.reloadData()
            
        })
        
       ref.removeAllObservers()
    
    }
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
   

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell

            cell.userImageView.sd_setImage(with: URL(string: "\(String(describing: users[(indexPath.row)].imagePath!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        
            let firstName = self.users[indexPath.row].firstName
            let lastName = self.users[indexPath.row].lastName
            let fullName = firstName! + " " + lastName!
            cell.nameLabel?.text = fullName
        
            return cell
    }
  
    
    
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        
    let vc = self.storyboard!.instantiateViewController(withIdentifier: "messageVC") as! Inbox
    let navController = UINavigationController(rootViewController: vc)
    //navController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
    let userIndex = tableView.indexPathForSelectedRow?.row
    let firstName = self.users[userIndex!].firstName
    let lastName = self.users[userIndex!].lastName
    let fullName = firstName! + " " + lastName!
    vc.title = fullName
    self.present(navController, animated: true, completion: nil)
    
    
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
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if  segue.identifier == "myText",
            let destination = segue.destination as? Inbox,
            let userIndex = tableView.indexPathForSelectedRow?.row
        {
     
        }
    } */
    

}
