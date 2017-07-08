//
//  AttendeesTable.swift
//  Linq
//
//  Created by Quinton Askew on 7/4/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class AttendeesTable: UITableViewController {

    @IBAction func doneViewingAttendees(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    
    }
    
   var acceptedUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
       self.navigationController?.navigationBar.barTintColor = UIColor.black
        tableView.rowHeight = 550
        
        retrieveAcceptedUsers() // Needs query
        
    }

    
    func retrieveAcceptedUsers() {
        Globals.ShowSpinner(testStr: "")
        let ref = Database.database().reference()
        
        ref.child("Users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            self.acceptedUsers.removeAll()
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
                            self.acceptedUsers.append(userToShow)
                            
                            
                        }
                        
                        
                    }
                    
                }
            }
            Globals.HideSpinner()
            self.tableView.reloadData()
            
        })
        ref.removeAllObservers()
        
        
        
    }
    

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acceptedUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendeesCell", for: indexPath) as! AttendeesCell
        
       let firstName = acceptedUsers[indexPath.row].firstName
       let lastName = acceptedUsers[indexPath.row].lastName
       let space = " "
       let name = "\(firstName!)\(space)\(lastName!)"
       let age = acceptedUsers[indexPath.row].age
       let gender = acceptedUsers[indexPath.row].gender
       let ageAndGender = "\(age!), \(gender!)"
        
        cell.nameLabel.text = name
        cell.ageAndGenderLabel.text = ageAndGender
        cell.userImageView.sd_setImage(with: URL(string: "\(String(describing: acceptedUsers[(indexPath.row)].imagePath!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))

        return cell
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
     
     @IBAction func unwindToInvitations(segue:UIStoryboardSegue) { }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
